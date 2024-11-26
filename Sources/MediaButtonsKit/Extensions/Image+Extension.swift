//
//  Image+Extension.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 29/10/2024.
//

import SwiftUI

extension Image {
    init(_ image: CGImage) {
        self.init(uiImage: UIImage(cgImage: image))
    }
}
