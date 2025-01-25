//
//  PhotoView.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 13/11/2024.
//

import SwiftUI
import Photos

enum MediaType {
    case camera
    case library
}

struct PhotoView<Item: PhotoItem>: View {
    let type: MediaType
    @Bindable var item: Item
    var asset: PhotoAsset?
    var cache: CachedImageManager?
    var snapshot: Photo?
    @Binding var isPresented: Bool
    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?
    @Environment(\.dismiss) var dismiss
    private let imageSize = CGSize(width: 1024, height: 1024)
    
    
    init(
        type: MediaType,
        item: Item,
        asset: PhotoAsset? = nil,
        cache: CachedImageManager? = nil,
        snapshot: Photo? = nil,
        isPresented: Binding<Bool>
    ) {
        self.type = type
        self.item = item
        self.asset = asset
        self.cache = cache
        self.snapshot = snapshot
        self._isPresented = isPresented
    }
    
    var body: some View {
        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.secondary)
        .navigationTitle("Photo")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            buttonsView({
                Task {
                    if type == .library {
                        guard let asset else { return }
                        item.imageData = await asset.fetchData()
                    } else {
                        guard let snapshot else { return }
                        item.imageData = snapshot.data
                    }
                    await MainActor.run {
                        isPresented = false
                    }
                }
            }, firstLabel: {
                Label("Add", systemImage: "plus")
                    .font(.system(size: 24))
            }, secondAction: {
                Task {
                    if type == .library {
                        guard let asset else { return }
                        await asset.delete()
                        await MainActor.run {
                            dismiss()
                        }
                    } else {
                        dismiss()
                    }
                }
            }, secondLabel: {
                Label("Delete", systemImage: "trash")
                    .font(.system(size: 24))
            })
            .offset(x: 0, y: -50)
        }
        .task {
            if type == .library {
                guard image == nil, let cache = cache, let asset else { return }
                imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { @Sendable result in
                    Task {
                        if let result = result {
                            await MainActor.run {
                                self.image = result.image
                            }
                        }
                    }
                }
            } else {
                guard let snapshot, let uiimage = UIImage(data: snapshot.data) else { return }
                self.image = Image(uiImage: uiimage)
            }
        }
    }
}

@MainActor
fileprivate func buttonsView<F: View, S: View>(_ firstAction: @escaping () -> Void, @ViewBuilder firstLabel: () -> F, secondAction: @escaping () -> Void, @ViewBuilder secondLabel: () -> S) -> some View {
    HStack(spacing: 60) {
        Button(action: firstAction, label: firstLabel)
        Button(action: secondAction, label: secondLabel)
    }
    .buttonStyle(.plain)
    .labelStyle(.iconOnly)
    .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
    .background(Color.secondary.colorInvert())
    .cornerRadius(15)
}

#Preview {
    buttonsView {
        
    } firstLabel: {
        Label("Add", systemImage: "plus")
            .font(.system(size: 24))
    } secondAction: {
        
    } secondLabel: {
        Label("Delete", systemImage: "trash")
            .font(.system(size: 24))
    }

}
