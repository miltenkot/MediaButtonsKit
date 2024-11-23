//
//  GalleryModel.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 11/11/2024.
//

import SwiftUI
import Photos

@Observable
final class GalleryModel {
    let photoCollection = PhotoCollection()
    
    // MARK: - Authorization
    /// A Boolean value that indicates whether a person authorizes this app to use
    /// device cameras and microphones. If they haven't previously authorized the
    /// app, querying this property prompts them for authorization.
    var isAuthorized: Bool {
        get async {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            // Determine whether a person previously authorized camera access.
            var isAuthorized = status == .authorized
            // If the system hasn't determined their authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await PHPhotoLibrary.requestAuthorization(for: .readWrite) == .authorized
            }
            return isAuthorized
        }
    }
    
    var isPhotosLoaded = false
    
    func loadPhotos() async {
        guard !isPhotosLoaded else { return }
        
        guard await isAuthorized else {
            logger.error("Photo library access was not authorized.")
            return
        }
        
        Task {
            do {
                try await self.photoCollection.load()
            } catch let error {
                logger.error("Failed to load photo collection: \(error.localizedDescription)")
            }
            self.isPhotosLoaded = true
        }
    }
}

extension GalleryModel: @unchecked Sendable {}
