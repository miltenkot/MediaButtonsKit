//
//  SwitchCameraButton.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI

/// A view that displays a button to switch between available cameras.
public struct SwitchCameraButton<CameraModel: Camera>: View {
    @State var camera: CameraModel
    
    public init(camera: CameraModel) {
        self.camera = camera
    }
    
    public var body: some View {
        Button {
            Task {
                await camera.switchVideoDevices()
            }
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath")
        }
        .frame(width: CGSize.largeButtonSize.width, height: CGSize.largeButtonSize.height)
    }
}
