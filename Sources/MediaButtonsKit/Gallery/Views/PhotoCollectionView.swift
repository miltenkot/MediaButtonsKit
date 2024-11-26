//
//  PhotoCollectionView.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 11/11/2024.
//

import SwiftUI

struct PhotoCollectionView<Item: PhotoItem>: View {
    @Environment(\.displayScale) private var displayScale
    
    private let itemSpacing: CGFloat = 2
    private let itemCornerRadius: CGFloat = 8
    private let itemSize = CGSize(width: 180, height: 180)
    
    private var imageSize: CGSize {
        CGSize(width: itemSize.width * min(displayScale, 2), height: itemSize.height * min(displayScale, 2))
    }
    
    var dividerValue: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 6
        default:
            return 3
        }
    }
    
    func thumbnailSize() -> CGSize {
        CGSize(width: UIScreen.main.bounds.size.width / dividerValue - itemSpacing, height: UIScreen.main.bounds.size.width / dividerValue - itemSpacing)
    }
    
    @Bindable var item: Item
    @Bindable var photoCollection: PhotoCollection
    @Binding var isPresented: Bool
    
    var body: some View {
        Group {
            if !photoCollection.photoAssets.isEmpty {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: thumbnailSize().width, maximum: thumbnailSize().width), spacing: itemSpacing)
                    ], spacing: itemSpacing) {
                        ForEach(photoCollection.photoAssets) { asset in
                            NavigationLink {
                                PhotoView(type: .library, item: item, asset: asset, cache: photoCollection.cache, isPresented: $isPresented)
                            } label: {
                                photoItemView(asset: asset, imageSize: imageSize)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
            } else {
                ContentUnavailableView(
                    "No photos available",
                    systemImage: "photo.badge.exclamationmark.fill",
                    description: Text("Check your permissions or add new photos")
                )
            }
        }
        .navigationTitle(photoCollection.albumName ?? "Gallery")
        .statusBar(hidden: false)
    }
    
    private func photoItemView(asset: PhotoAsset, imageSize: CGSize) -> some View {
        PhotoItemView(asset: asset, cache: photoCollection.cache, imageSize: imageSize)
            .frame(width: thumbnailSize().width, height: thumbnailSize().height)
            .clipped()
            .cornerRadius(itemCornerRadius)
            .onAppear {
                Task {
                    await photoCollection.cache.startCaching(for: [asset], targetSize: imageSize)
                }
            }
            .onDisappear {
                Task {
                    await photoCollection.cache.stopCaching(for: [asset], targetSize: imageSize)
                }
            }
    }
}

#if DEBUG

#Preview {
    @Previewable @State var item = MockPhotoItem()
    @Previewable @State var photoCollection: PhotoCollection = PhotoCollection()
    @Previewable @State var isPresented: Bool = true
    //TODO: add protocol PhotoCollection to display in preview
    PhotoCollectionView(item: item, photoCollection: photoCollection, isPresented: $isPresented)
}

#endif
