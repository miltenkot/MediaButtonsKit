//
//  CameraUI.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI
import PhotosUI

struct CameraUI<CameraModel: Camera>: View {
    @State var camera: CameraModel
    let leadingButton: LeadingButton
    @Binding var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                MainToolbar(camera: camera, selectedItem: $selectedItem, leadingButton: leadingButton)
            }
        }
        .overlay {
            StatusOverlayView(status: camera.status)
                .ignoresSafeArea()
        }
    }
}
