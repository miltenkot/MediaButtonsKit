//
//  CaptureButton.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI

@MainActor
struct CaptureButton<CameraModel: Camera>: View {
    @State var camera: CameraModel
    private let mainButtonDimension: CGFloat = 68
    
    var body: some View {
        PhotoCaptureButton {
            Task {
                await camera.capturePhoto()
            }
        }
        .scaledToFit()
        .frame(width: mainButtonDimension)
    }
}

private struct PhotoCaptureButton: View {
    private let action: () -> Void
    private let lineWidth = CGFloat(4.0)
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .fill(.white)
            Button {
                action()
            } label: {
                Circle()
                    .inset(by: lineWidth * 1.2)
                    .fill(.white)
            }
            .buttonStyle(PhotoButtonStyle())
        }
    }
    
    struct PhotoButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
        }
    }
}

#Preview {
    CaptureButton(camera: PreviewCameraModel())
        .preferredColorScheme(.dark)
}
