//
//  SnapshotView.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 11/11/2024.
//

import SwiftUI

// template of real view
struct SnapshotView<Item: PhotoItem>: View {
    @Bindable var item: Item
    @Binding var isPresented: Bool
    let snapshot: Photo?
    
    var body: some View {
        PhotoView(type: .camera, item: item, asset: nil, cache: nil, snapshot: snapshot, isPresented: $isPresented)
    }
}
