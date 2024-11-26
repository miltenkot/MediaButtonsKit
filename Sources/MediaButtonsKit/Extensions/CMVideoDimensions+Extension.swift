//
//  CMVideoDimensions+Extension.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 29/10/2024.
//

import AVFoundation

extension CMVideoDimensions: @retroactive Equatable, @retroactive Comparable {
    
    static let zero = CMVideoDimensions()
    
    public static func == (lhs: CMVideoDimensions, rhs: CMVideoDimensions) -> Bool {
        lhs.width == rhs.width && lhs.height == rhs.height
    }
    
    public static func < (lhs: CMVideoDimensions, rhs: CMVideoDimensions) -> Bool {
        lhs.width < rhs.width && lhs.height < rhs.height
    }
}
