//
//  PhotoLibraryAuthorization.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 26/11/2024.
//

import Photos

import Photos

/// A protocol that abstracts photo library authorization behavior.
/// This allows for mocking or substituting the actual `PHPhotoLibrary` authorization logic in tests.
protocol PhotoLibraryAuthorization {
    /// Retrieves the current authorization status for accessing the photo library.
    /// - Returns: The current `PHAuthorizationStatus` for read-write access.
    func authorizationStatus() -> PHAuthorizationStatus
    
    /// Requests authorization to access the photo library.
    /// - Returns: The `PHAuthorizationStatus` after the user's response.
    func requestAuthorization() async -> PHAuthorizationStatus
}

/// The default implementation of `PhotoLibraryAuthorization` that uses `PHPhotoLibrary`.
final class DefaultPhotoLibraryAuthorization: PhotoLibraryAuthorization {
    /// Retrieves the current authorization status for accessing the photo library.
    /// - Returns: The current `PHAuthorizationStatus` for read-write access.
    func authorizationStatus() -> PHAuthorizationStatus {
        PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    /// Requests authorization to access the photo library by prompting the user.
    /// - Returns: The `PHAuthorizationStatus` after the user's response.
    func requestAuthorization() async -> PHAuthorizationStatus {
        await PHPhotoLibrary.requestAuthorization(for: .readWrite)
    }
}

