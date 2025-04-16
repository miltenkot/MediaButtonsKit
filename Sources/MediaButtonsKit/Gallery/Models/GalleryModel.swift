//
//  GalleryModel.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 11/11/2024.
//

import SwiftUI

@Observable
/// A model responsible for managing photo library access and loading thumbnail images.
final class GalleryModel {
    /// The photo collection instance responsible for managing photo assets.
    let photoCollection: PhotoCollection
    /// The thumbnail image of the first photo asset in the collection.
    @MainActor var thumbnailImage: Image?
    
    private let photoLibraryAuthorization: PhotoLibraryAuthorization
    
    init(photoLibraryAuthorization: PhotoLibraryAuthorization = DefaultPhotoLibraryAuthorization(), photoCollection: PhotoCollection = PhotoCollection()) {
        self.photoCollection = photoCollection
        self.photoLibraryAuthorization = photoLibraryAuthorization
    }
    
    // MARK: - Authorisation
    /// A Boolean value that indicates whether a person authorises this app to use
    /// device cameras and microphones. If they haven't previously authorised the
    /// app, querying this property prompts them for authorisation.
    var isAuthorized: Bool {
        get async {
            let status = photoLibraryAuthorization.authorizationStatus()
            var isAuthorized = status == .authorized
            if status == .notDetermined {
                isAuthorized = await photoLibraryAuthorization.requestAuthorization() == .authorized
            }
            return isAuthorized
        }
    }
    
    /// A flag indicating whether the photo assets have been successfully loaded.
    var isPhotosLoaded = false
    
    // MARK: - Methods
    
    /// Loads the photos from the photo library and fetches the first photo's thumbnail.
    /// If the user hasn't authorised access, the method logs an error and exits.
    func loadPhotos() async {
        // Skip loading if photos are already loaded.
        guard !isPhotosLoaded else { return }
        
        // Check authorisation status.
        guard await isAuthorized else {
            logger.error("Photo library access was not authorized.")
            return
        }
        
        do {
            try await self.photoCollection.load()
            await self.loadThumbnail()
        } catch let error {
            logger.error("Failed to load photo collection: \(error.localizedDescription)")
        }
        
        self.isPhotosLoaded = true
    }
    
    /// Loads a thumbnail image for the first photo asset in the collection.
    /// If the photo collection is empty, the method does nothing.
    func loadThumbnail() async {
        // Check if there is a photo asset to fetch.
        guard let asset = photoCollection.photoAssets.first else { return }
        
        // Request a thumbnail image of the specified size from the photo cache.
        await photoCollection.cache.requestImage(for: asset, targetSize: CGSize(width: 256, height: 256))  { @Sendable [weak self] result in
            if let result = result {
                Task { @MainActor in
                    self?.thumbnailImage = result.image
                    logger.info("thumbnailImage loaded")
                }
            }
        }
    }
}

extension GalleryModel: @unchecked Sendable {}
