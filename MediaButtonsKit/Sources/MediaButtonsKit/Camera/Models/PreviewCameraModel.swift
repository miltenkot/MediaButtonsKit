//
//  PreviewCameraModel.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 25/10/2024.
//

import Foundation
import SwiftUI

@Observable
final class PreviewCameraModel: Camera {

    var shouldFlashScreen = false
    var isHDRVideoSupported = false
    var isHDRVideoEnabled = false
    
    private(set) var status = CameraStatus.unknown
    private(set) var captureActivity = CaptureActivity.idle
    var captureMode = CaptureMode.photo {
        didSet {
            isSwitchingModes = true
            Task {
                // Create a short delay to mimic the time it takes to reconfigure the session.
                try? await Task.sleep(until: .now + .seconds(0.3), clock: .continuous)
                self.isSwitchingModes = false
            }
        }
    }
    
    private(set) var isSwitchingModes: Bool = false
    private(set) var isSwitchingVideoDevices: Bool = false
    private(set) var photoFeatures = PhotoFeatures()
    private(set) var thumbnail: CGImage?
    var snapshot: Photo?
    var isCameraPreviewPresented: Bool = true
    
    struct PreviewSourceStub: PreviewSource {
        // Stubbed out for test purposes.
        func connect(to target: PreviewTarget) {}
    }
    
    var error: Error?
    
    init(captureMode: CaptureMode = .photo, status: CameraStatus = .unknown) {
        self.captureMode = captureMode
        self.status = status
    }
    
    func start() async {
        if status == .unknown {
            status = .running
        }
    }
    
    let previewSource: PreviewSource = PreviewSourceStub()
    
    func switchVideoDevices() {
        logger.debug("Device switching isn't implemented in PreviewCamera.")
    }
    
    func capturePhoto() {
        logger.debug("Photo capture isn't implemented in PreviewCamera.")
    }
    
    func focusAndExpose(at point: CGPoint) {
        logger.debug("Focus and expose isn't implemented in PreviewCamera.")
    }
    
    func toggleRecording() {
        logger.debug("Moving capture isn't implemented in PreviewCamera.")
    }
}
