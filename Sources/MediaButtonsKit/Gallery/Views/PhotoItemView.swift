//
//  PhotoItemView.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 13/11/2024.
//

import SwiftUI
import Photos

struct PhotoItemView: View {
    var asset: PhotoAsset
    var cache: CachedImageManager?
    var imageSize: CGSize
    
    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?

    var body: some View {
        
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .scaleEffect(0.5)
            }
        }
        .task {
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { @Sendable result in
                Task {
                    if let result = result {
                        await MainActor.run {
                            self.image = result.image
                        }
                    }
                }
            }
        }
    }
}
