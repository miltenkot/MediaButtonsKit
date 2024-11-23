//
//  SwiftUIView.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI
import PhotosUI

enum SwipeDirection {
    case left
    case right
    case up
    case down
}

@MainActor
struct CameraView<CameraModel: Camera, Item: PhotoItem>: View {
    @Bindable var item: Item
    @State var camera: CameraModel
    // The direction a person swipes on the camera preview or mode selector.
    @State var swipeDirection = SwipeDirection.left
    let leadingButton: LeadingButton
    @Binding var isCameraPreviewPresented: Bool
    
    @State var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ZStack {
            PreviewContainer(camera: camera) {
                CameraPreview(source: camera.previewSource)
                    .onTapGesture { location in
                        // Focus and expose at the tapped point.
                        Task { await camera.focusAndExpose(at: location) }
                    }
                    .simultaneousGesture(swipeGesture)
                    /// The value of `shouldFlashScreen` changes briefly to `true` when capture
                    /// starts, then immediately changes to `false`. Use this to
                    /// flash the screen to provide visual feedback.
                    .opacity(camera.shouldFlashScreen ? 0 : 1)
            }
            CameraUI(camera: camera, leadingButton: leadingButton, selectedItem: $selectedItem)
                .onChange(of: selectedItem) { oldValue, newValue in
                    Task {
                        item.imageData = try await newValue?.loadTransferable(type: Data.self)
                    }
                }
        }
        .sheet(item: $camera.snapshot) { snapshot in
            SnapshotView(item: item, isPresented: $isCameraPreviewPresented, snapshot: snapshot)
        }
    }
    
    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 50)
            .onEnded {
                // Capture swipe direction.
                swipeDirection = $0.translation.width < 0 ? .left : .right
            }
    }
}

#Preview {
    CameraView(item: MockPhotoItem(), camera: PreviewCameraModel(), leadingButton: .thumbnail, isCameraPreviewPresented: .constant(true))
        .preferredColorScheme(.dark)
}
