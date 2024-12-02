//
//  GalleryButton.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI

public struct GalleryButton<Item: PhotoItem, Text: View, Label: View, ToolbarItemContent: View>: View {
    @Bindable var item: Item
    let text: Text
    let label: Label
    let toolbarItemContent: ToolbarItemContent
    let toolbarItemPlacement: ToolbarItemPlacement
    @Binding var isGalleryPresented: Bool
    @State private var galery = GalleryModel()
    
    public init(item: Item,
                @ViewBuilder text: () -> Text = { SwiftUI.Text("Gallery").bold() },
                @ViewBuilder label: () -> Label = { EmptyView() },
                @ViewBuilder toolbarItemContent: () -> ToolbarItemContent = { EmptyView() },
                toolbarItemPlacement: ToolbarItemPlacement = .navigation,
                isGalleryPresented: Binding<Bool>) {
        self.item = item
        self.text = text()
        self.label = label()
        self.toolbarItemContent = toolbarItemContent()
        self.toolbarItemPlacement = toolbarItemPlacement
        self._isGalleryPresented = isGalleryPresented
    }
    
    public var body: some View {
        Button {
            isGalleryPresented = true
        } label: {
            buttonLabel
                .frame(maxWidth: .infinity)
                .fullScreenCover(isPresented: $isGalleryPresented) {
                    NavigationStack {
                        PhotoCollectionView(item: item, photoCollection: galery.photoCollection, isPresented: $isGalleryPresented)
                            .toolbar {
                                ToolbarItem(placement: toolbarItemPlacement) {
                                    toolbarItemContent
                                }
                            }
                    }
                }
        }
        .task {
            await galery.loadPhotos()
            await galery.loadThumbnail()
        }
    }
    
    @ViewBuilder
    private var buttonLabel: some View {
        if label is EmptyView {
            SwiftUI.Label {
                text
            } icon: {
                ThumbnailView(image: galery.thumbnailImage)
            }
        } else {
            label
        }
    }
}
#if DEBUG
#Preview {
    @Previewable @State var item = MockPhotoItem()
    @Previewable @State var isGalleryPresented = false
    GalleryButton(item: item, isGalleryPresented: $isGalleryPresented)
}
#endif
