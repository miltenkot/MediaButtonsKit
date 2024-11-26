//
//  PhotoItem.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 24/11/2024.
//

import Foundation

/// A protocol that defines the requirements for an object representing a selected photo item.
///
/// Any class conforming to this protocol will:
/// - Receive the binary data of the selected photo as a `Data` object.
/// - Support observation of changes through the `Observable` protocol.
public protocol PhotoItem: AnyObject, Observable {
    /// The binary data of the selected photo.
    ///
    /// This property contains the photo's data as a `Data?` object.
    /// It may be `nil` if no photo is currently selected.
    var imageData: Data? { get set }
}

#if DEBUG
class MockPhotoItem: PhotoItem {
    var imageData: Data?
}
#endif
