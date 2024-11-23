//
//  MockPhotoLibraryAuthorization.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 26/11/2024.
//

import Photos
@testable import MediaButtonsKit

class MockPhotoLibraryAuthorization: PhotoLibraryAuthorization {
    private let mockStatus: PHAuthorizationStatus
    private let mockRequestStatus: PHAuthorizationStatus

    init(mockStatus: PHAuthorizationStatus, mockRequestStatus: PHAuthorizationStatus = .notDetermined) {
        self.mockStatus = mockStatus
        self.mockRequestStatus = mockRequestStatus
    }

    func authorizationStatus() -> PHAuthorizationStatus {
        mockStatus
    }

    func requestAuthorization() async -> PHAuthorizationStatus {
        mockRequestStatus
    }
}
