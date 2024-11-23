//
//  MainToolbar.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI

public enum LeadingButton {
    case dismiss
    case thumbnail
}

struct MainToolbar<CameraModel: Camera>: View {

    @State var camera: CameraModel
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
            ThumbnailButton(camera: camera)
        }
    }
}

#Preview {
    MainToolbar(camera: PreviewCameraModel(), leadingButton: .thumbnail)
        .preferredColorScheme(.dark)
}
