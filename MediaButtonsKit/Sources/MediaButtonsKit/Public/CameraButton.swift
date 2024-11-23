//
//  CameraButton.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/10/2024.
//

import SwiftUI

@ViewBuilder
public var defaultCameraLabel: some View {
    SwiftUI.Label {
        Text("Camera")
            .bold()
    } icon: {
        Image(systemName: "camera.circle")
            .symbolRenderingMode(.hierarchical)
            .resizable()
            .scaledToFit()
            .font(.system(size: 28))
            .frame(width: 41, height: 41)
    }
}

public struct CameraButton<Item: PhotoItem, Label: View>: View {
    // Simulator doesn't support the AVFoundation capture APIs. Use the preview camera when running in Simulator.
    @Bindable var item: Item
    let label: Label
    @State private var camera: CameraModel
    let leadingButton: LeadingButton
    let useUserPreferredCamera: Bool
    let showImageSnapshotSheet: Bool
    let saveInLibrary: Bool
    
    @State private var isCameraPresented = false
    
    public init(item: Item,
                @ViewBuilder label: () -> Label = { defaultCameraLabel },
                leadingButton: LeadingButton = .thumbnail,
                useUserPreferredCamera: Bool = false,
                showImageSnapshotSheet: Bool = false,
                saveInLibrary: Bool = true) {
        self.item = item
        self.label = label()
        self.leadingButton = leadingButton
        self.useUserPreferredCamera = useUserPreferredCamera
        self.showImageSnapshotSheet = showImageSnapshotSheet
        self.saveInLibrary = saveInLibrary
        self.camera = CameraModel(useUserPreferredCamera: useUserPreferredCamera, showImageSnapshotSheet: showImageSnapshotSheet, saveInLibrary: saveInLibrary)
    }
    
    public var body: some View {
        Button {
            isCameraPresented = true
        } label: {
            label
        }
        .fullScreenCover(isPresented: $isCameraPresented) {
            NavigationStack {
                CameraView(item: item, camera: camera, leadingButton: leadingButton, isCameraPreviewPresented: $isCameraPresented)
                    .background(.black)
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Button("", systemImage: "xmark") {
                                isCameraPresented = false
                            }
                        }
                    }
                    .task {
                        // Start the capture pipeline.
                        await camera.start()
                    }
            }
        }
    }
}

#Preview {
    CameraButton(item: MockPhotoItem())
}
