//
//  LiveExampleApp.swift
//  MediaButtonsKitDemo
//
//  Created by Bartlomiej Lanczyk on 26/11/2024.
//

import SwiftUI
import MediaButtonsKit

struct LiveExampleApp: View {
    @Bindable var item = MockPhotoItem()
    @State private var isPresented = false
    @State private var isGalleryIsPresented = false
    @State private var isCameraIsPresented = false

    var body: some View {
        Button {
            isPresented = true
        } label: {
            if let data = item.imageData {
                Image(uiImage: UIImage(data: data)!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(maxHeight: 300)
            } else {
                Image(systemName: "photo.fill")
                    .font(.system(size: 48))
                    .padding(32)
                    .background(Color(uiColor: UIColor.secondarySystemGroupedBackground))
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $isPresented) {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    GalleryButton(item: item,
                                  toolbarItemContent: {
                        Button {
                            isGalleryIsPresented = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .fontDesign(.rounded)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity)
                    },
                                  toolbarItemPlacement: .topBarTrailing,
                                  isGalleryPresented: $isGalleryIsPresented)
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                    
                    CameraButton(item: item,
                                 leadingButton: .dismiss,
                                 showImageSnapshotSheet: true,
                                 saveInLibrary: false,
                                 isCameraPresented: $isCameraIsPresented)
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .presentationDragIndicator(.visible)
            .presentationDetents([.fraction(0.3)])
            .presentationCornerRadius(32)
        }
    }
}
