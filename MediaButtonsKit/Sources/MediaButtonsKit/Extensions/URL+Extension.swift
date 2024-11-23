//
//  URL+Extension.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 29/10/2024.
//

import Foundation

extension URL {
    /// A unique output location to write a movie.
    static var movieFileURL: URL {
        URL.temporaryDirectory.appending(component: UUID().uuidString).appendingPathExtension(for: .quickTimeMovie)
    }
}
