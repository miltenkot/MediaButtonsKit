//
//  MovieCapture.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 29/10/2024.
//

import AVFoundation
import Combine

/// An object that manages a movie capture output to record videos.
final class MovieCapture: OutputService {
    /// The capture output type for this service.
    let output = AVCaptureMovieFileOutput()
    
    /// A value that indicates the current state of movie capture.
    @Published private(set) var captureActivity: CaptureActivity = .idle
    
    // A Boolean value that indicates whether the currently selected camera's
    // active format supports HDR.
    private var isHDRSupported = false
    
    func updateConfiguration(for device: AVCaptureDevice) {
        // The app supports HDR video capture if the active format supports it.
        isHDRSupported = device.activeFormat10BitVariant != nil
    }
    
    // MARK: - Configuration
    /// Returns the capabilities for this capture service.
    var capabilities: CaptureCapabilities {
        CaptureCapabilities(isHDRSupported: isHDRSupported)
    }
}
