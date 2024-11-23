//
//  MediaLibrary.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 29/10/2024.
//

import Foundation
import Photos
import UIKit

/// An object that writes photos and movies to the user's Photos library.
actor MediaLibrary {
    // Errors that media library can throw.
    enum Error: Swift.Error {
        case unauthorized
        case saveFailed
    }
    
    /// An asynchronous stream of thumbnail images the app generates after capturing media.
    let thumbnails: AsyncStream<CGImage?>
    private let continuation: AsyncStream<CGImage?>.Continuation?
    
    /// Creates a new media library object.
    init() {
        let (thumbnails, continuation) = AsyncStream.makeStream(of: CGImage?.self)
        self.thumbnails = thumbnails
        self.continuation = continuation
    }
    
    // MARK: - Authorization
    
    private var isAuthorized: Bool {
        get async {
            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
            /// Determine whether the user has previously authorized `PHPhotoLibrary` access.
            var isAuthorized = status == .authorized
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                // Request authorization to add media to the library.
                let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                isAuthorized = status == .authorized
            }
            return isAuthorized
        }
    }
    
    // MARK: - Saving media
    
    /// Saves a photo to the Photos library.
    func save(photo: Photo) async throws {
        try await performChange {
            let creationRequest = PHAssetCreationRequest.forAsset()
            
            // Save primary photo.
            let options = PHAssetResourceCreationOptions()
            // Specify the appropriate resource type for the photo.
            creationRequest.addResource(with: photo.isProxy ? .photoProxy : .photo, data: photo.data, options: options)
            
            // Save Live Photo data.
            if let url = photo.livePhotoMovieURL {
                let livePhotoOptions = PHAssetResourceCreationOptions()
                livePhotoOptions.shouldMoveFile = true
                creationRequest.addResource(with: .pairedVideo, fileURL: url, options: livePhotoOptions)
            }
            
            return creationRequest.placeholderForCreatedAsset
        }
    }
    
    // A template method for writing a change to the user's photo library.
    private func performChange(_ change: @Sendable @escaping () -> PHObjectPlaceholder?) async throws {
        guard await isAuthorized else {
            throw Error.unauthorized
        }
        
        do {
            var placeholder: PHObjectPlaceholder?
            try await PHPhotoLibrary.shared().performChanges {
                // Execute the change closure.
                placeholder = change()
            }
            
            if let placeholder {
                /// Retrieve the newly created `PHAsset` instance.
                guard let asset = PHAsset.fetchAssets(withLocalIdentifiers: [placeholder.localIdentifier],
                                                      options: nil).firstObject else { return }
                await createThumbnail(for: asset)
            }
        } catch {
            throw Error.saveFailed
        }
    }
    
    // MARK: - Thumbnail handling
    
    private func createThumbnail(for asset: PHAsset) async {
        // Request the generation of a 256x256 thumbnail image.
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: .init(width: 256, height: 256),
                                              contentMode: .default,
                                              options: nil) { [weak self] image, _ in
            // Set the latest thumbnail image.
            guard let self, let image = image else { return }
            continuation?.yield(image.cgImage)
        }
    }
}
