//
//  DismissButton.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 25/10/2024.
//

import SwiftUI

/// A view that displays a button to switch between available cameras.
public struct DismissButton: View {
    @Environment(\.dismiss) var dismiss
    
    public init() {}
    
    public var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 32))
                .fontDesign(.rounded)
                .symbolRenderingMode(.hierarchical)
        }
        .frame(width: CGSize.largeButtonSize.width, height: CGSize.largeButtonSize.height)
    }
}

#Preview {
    DismissButton()
}
