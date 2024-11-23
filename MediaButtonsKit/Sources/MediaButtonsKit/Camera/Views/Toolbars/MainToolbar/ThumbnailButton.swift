//
//  ThumbnailButton.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI
import PhotosUI

/// A view that displays a thumbnail of the last captured media.
///
/// Tapping the view opens the Photos picker.
public struct ThumbnailButton<CameraModel: Camera>: View {
    @State var camera: CameraModel
    @Binding var selectedItem: PhotosPickerItem?
    
    public init(camera: CameraModel, selectedItem: Binding<PhotosPickerItem?>) {
        self.camera = camera
        self._selectedItem = selectedItem
    }
    
    public var body: some View {
        photoPicker
        .frame(width: CGSize.largeButtonSize.width, height: CGSize.largeButtonSize.height)
        .cornerRadius(8)
        .disabled(camera.captureActivity.isRecording)
    }
    
    @ViewBuilder
    private var photoPicker: some View {
        let filter = PHPickerFilter.images
        let photoLibrary = PHPhotoLibrary.shared()
        PhotosPicker(selection: $selectedItem, matching: filter, photoLibrary: photoLibrary) { [thumbnail = camera.thumbnail] in
            PhotoImage(thumbnail: thumbnail)
        }
    }
}

struct PhotoImage: View {
    let thumbnail: CGImage?

    var body: some View {
        if let thumbnail {
            Image(thumbnail)
                .resizable()
                .scaledToFill()
                .animation(.easeInOut(duration: 0.3), value: thumbnail)
        } else {
            Image(systemName: "photo.on.rectangle")
        }
    }
}
