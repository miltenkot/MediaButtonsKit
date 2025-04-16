//
//  SwipeToDismiss.swift
//  MediaButtonsKit
//
//  Created by Bartlomiej Lanczyk on 16/04/2025.
//

import SwiftUI

struct SwipeToDismiss: ViewModifier {
    @Binding var isPresented: Bool
    @State private var dragOffset: CGFloat = 0
    private let dragThreshold: CGFloat = 100
    
    func body(content: Content) -> some View {
        content
            .offset(y: dragOffset)
            .opacity(opacity(for: dragOffset))
            .gesture(
                DragGesture()
                    .onChanged { drag in
                        withAnimation(.spring()) {
                            dragOffset = max(drag.translation.height, 0)
                        }
                    }
                    .onEnded { drag in
                        withAnimation(.spring()) {
                            if drag.translation.height > dragThreshold {
                                isPresented = false
                            } else {
                                dragOffset = 0
                            }
                        }
                    }
            )
    }
    
    private func opacity(for offset: CGFloat) -> Double {
        max(1.0 - Double(offset / dragThreshold), 0)
    }
}

extension View {
    func swipeToDismiss(_ isPresented: Binding<Bool>) -> some View {
        self.modifier(SwipeToDismiss(isPresented: isPresented))
    }
}
