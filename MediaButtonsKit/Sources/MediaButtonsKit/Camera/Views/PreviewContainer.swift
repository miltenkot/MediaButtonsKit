//
//  PreviewContainer.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI

/// A view that provides a container view around the camera preview.
///
/// This view applies transition effects when changing capture modes or switching devices.
/// On a compact device size, the app also uses this view to offset the vertical position
/// of the camera preview to better fit the UI when in photo capture mode.
struct PreviewContainer<Content: View, CameraModel: Camera>: View {
    private let content: Content
    
    @State var camera: CameraModel
    
    // State values for transition effects.
    @State private var blurRadius = CGFloat.zero
    
    init(camera: CameraModel, @ViewBuilder content: () -> Content) {
        self.camera = camera
        self.content = content()
    }
    var body: some View {
        previewView
            .clipped()
            .aspectRatio(CGSize(width: 3, height: 4), contentMode: .fit)
            .offset(y: -44)
    }
    
    var previewView: some View {
        content
            .blur(radius: blurRadius)
            .onChange(of: camera.isSwitchingModes, updateBlurRadius(_:_:))
            .onChange(of: camera.isSwitchingVideoDevices, updateBlurRadius(_:_:))
    }
    
    func updateBlurRadius(_: Bool, _ isSwitching: Bool) {
        withAnimation {
            blurRadius = isSwitching ? 30 : 0
        }
    }
}

#Preview {
    PreviewContainer(camera: PreviewCameraModel()) {
        Color.red
    }
}
