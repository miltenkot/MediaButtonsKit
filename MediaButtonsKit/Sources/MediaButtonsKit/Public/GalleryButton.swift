//
//  GalleryButton.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI

public struct GalleryButton<Item: PhotoItem>: View {
    @Bindable var item: Item
    
    @State private var isGalleryPresented = false
    @State private var galery = GalleryModel()
    
    public init(item: Item) {
        self.item = item
    }
    
    public var body: some View {
        Button {
            isGalleryPresented = true
        } label: {
            Text("Gallery")
                .bold()
                .fullScreenCover(isPresented: $isGalleryPresented) {
                    NavigationStack {
                        PhotoCollectionView(item: item, photoCollection: galery.photoCollection, isPresented: $isGalleryPresented)
                            .task {
                                await galery.loadPhotos()
                            }
                            .toolbar {
                                ToolbarItem(placement: .navigation) {
                                    Button("", systemImage: "xmark") {
                                        isGalleryPresented = false
                                    }
                                }
                            }
                    }
                }
        }
    }
}

//#Preview {
//    GalleryButton()
//}
