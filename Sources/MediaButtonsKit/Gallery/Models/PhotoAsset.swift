//
//  PhotoAsset.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 11/11/2024.
//

import Photos

struct PhotoAsset: Identifiable {
    var id: String { identifier }
    var identifier: String = UUID().uuidString
    var index: Int?
    var phAsset: PHAsset?
    
    typealias MediaType = PHAssetMediaType
    
    var mediaType: MediaType {
        phAsset?.mediaType ?? .unknown
    }
    
    init(phAsset: PHAsset, index: Int?) {
        self.phAsset = phAsset
        self.index = index
        self.identifier = phAsset.localIdentifier
    }
    
    init(identifier: String) {
        self.identifier = identifier
        let fetchedAssets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        self.phAsset = fetchedAssets.firstObject
    }
    
    func fetchData() async -> Data? {
        guard let phAsset = phAsset else { return nil}
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.resizeMode = .none
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        options.isSynchronous = true
        
        return await withCheckedContinuation { continuation in
            manager.requestImageDataAndOrientation(for: phAsset, options: options) { data, _, _, _ in
                continuation.resume(returning: data)
            }
        }
    }
    
    @MainActor
    func delete() async {
        guard let phAsset = phAsset else { return }
        do {
            try await PHPhotoLibrary.shared().performChanges { @Sendable in
                PHAssetChangeRequest.deleteAssets([phAsset] as NSArray)
            }
            logger.debug("PhotoAsset asset deleted: \(index ?? -1)")
        } catch (let error) {
            logger.error("Failed to delete photo: \(error.localizedDescription)")
        }
    }
}

extension PhotoAsset: Equatable {
    static func ==(lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        (lhs.identifier == rhs.identifier)
    }
}

extension PhotoAsset: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
