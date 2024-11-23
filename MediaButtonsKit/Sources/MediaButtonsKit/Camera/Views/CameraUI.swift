//
//  CameraUI.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI

struct CameraUI<CameraModel: Camera>: View {
    @State var camera: CameraModel
    let leadingButton: LeadingButton
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                MainToolbar(camera: camera, leadingButton: leadingButton)
            }
        }
        .overlay {
            StatusOverlayView(status: camera.status)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    CameraUI(camera: PreviewCameraModel(), leadingButton: .thumbnail)
}
