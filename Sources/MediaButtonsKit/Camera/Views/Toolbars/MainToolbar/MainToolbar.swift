//
//  MainToolbar.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI
import PhotosUI

public enum LeadingButton {
    case dismiss
    case thumbnail
}

struct MainToolbar<CameraModel: Camera>: View {

    @State var camera: CameraModel
    @Binding var selectedItem: PhotosPickerItem?
    let leadingButton: LeadingButton
    
    var body: some View {
        HStack {
            leadingButtonView
            Spacer()
            CaptureButton(camera: camera)
            Spacer()
            SwitchCameraButton(camera: camera)
        }
        .padding(.horizontal)
        .foregroundColor(.white)
        .font(.system(size: 24))
    }
    
    @ViewBuilder
    private var leadingButtonView: some View {
        switch leadingButton {
        case .dismiss:
            DismissButton()
        case .thumbnail:
            ThumbnailButton(camera: camera, selectedItem: $selectedItem)
        }
    }
}
