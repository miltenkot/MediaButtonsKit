import Testing
import Foundation
@testable import MediaButtonsKit

struct GalleryModelTests {
    // MARK: PhotoLibraryAuthorization
    @Test func authorizedAccessToPhotos() async throws {
        let mockAuthorization = MockPhotoLibraryAuthorization(mockStatus: .authorized)
        let model = GalleryModel(photoLibraryAuthorization: mockAuthorization)

        let isAuthorized = await model.isAuthorized
        #expect(isAuthorized == true)
    }
    
    @Test func restrictedAccessToPhotos() async throws {
        let mockAuthorization = MockPhotoLibraryAuthorization(mockStatus: .restricted)
        let model = GalleryModel(photoLibraryAuthorization: mockAuthorization)

        let isAuthorized = await model.isAuthorized
        #expect(isAuthorized == false)
    }
    
    @Test func limitedAccessToPhotos() async throws {
        let mockAuthorization = MockPhotoLibraryAuthorization(mockStatus: .limited)
        let model = GalleryModel(photoLibraryAuthorization: mockAuthorization)

        let isAuthorized = await model.isAuthorized
        #expect(isAuthorized == false)
    }
    
    @Test func notDeterminedAccessToPhotosUserAuthorizedAccessToPhotos() async throws {
        let mockAuthorization = MockPhotoLibraryAuthorization(mockStatus: .notDetermined, mockRequestStatus: .authorized)
        let model = GalleryModel(photoLibraryAuthorization: mockAuthorization)

        let isAuthorized = await model.isAuthorized
        #expect(isAuthorized == true)
    }
    
    @Test func notDeterminedAccessToPhotosUserDeniedAccessToPhotos() async throws {
        let mockAuthorization = MockPhotoLibraryAuthorization(mockStatus: .notDetermined, mockRequestStatus: .denied)
        let model = GalleryModel(photoLibraryAuthorization: mockAuthorization)

        let isAuthorized = await model.isAuthorized
        #expect(isAuthorized == false)
    }
    
    @Test func notDeterminedAccessToPhotosUserLimitedAccessToPhotos() async throws {
        let mockAuthorization = MockPhotoLibraryAuthorization(mockStatus: .notDetermined, mockRequestStatus: .limited)
        let model = GalleryModel(photoLibraryAuthorization: mockAuthorization)

        let isAuthorized = await model.isAuthorized
        #expect(isAuthorized == false)
    }
    
    // MARK: Methods
    
    @Test func loadPhotosWhenNotAuthorized() async throws {
        let mockAuthorization = MockPhotoLibraryAuthorization(mockStatus: .restricted)
        let photoCollection = MockPhotoCollection()
        let model = GalleryModel(photoLibraryAuthorization: mockAuthorization, photoCollection: photoCollection)
        
        #expect(photoCollection.isPhotosLoaded == false)
        await model.loadPhotos()
        try await Task.sleep(nanoseconds: 1)
        #expect(photoCollection.isPhotosLoaded == false)
    }
    
    @Test func loadPhotosWhenNotLoaded() async throws {
        let mockAuthorization = MockPhotoLibraryAuthorization(mockStatus: .authorized)
        let photoCollection = MockPhotoCollection()
        let model = GalleryModel(photoLibraryAuthorization: mockAuthorization, photoCollection: photoCollection)
        
        #expect(photoCollection.isPhotosLoaded == false)
        await model.loadPhotos()
        try await Task.sleep(nanoseconds: 1)
        #expect(photoCollection.isPhotosLoaded == true)
    }
    
    @Test func loadPhotosWhenLoaded() async throws {
        let mockAuthorization = MockPhotoLibraryAuthorization(mockStatus: .authorized)
        let photoCollection = MockPhotoCollection()
        let model = GalleryModel(photoLibraryAuthorization: mockAuthorization, photoCollection: photoCollection)
        model.isPhotosLoaded = true
        
        #expect(photoCollection.isPhotosLoaded == false)
        await model.loadPhotos()
        try await Task.sleep(nanoseconds: 1)
        #expect(photoCollection.isPhotosLoaded == false)
    }
}

@Observable
class MockPhotoCollection: PhotoCollection, @unchecked Sendable {
    var isPhotosLoaded = false
    
    override func load() async throws {
        isPhotosLoaded = true
    }
}
