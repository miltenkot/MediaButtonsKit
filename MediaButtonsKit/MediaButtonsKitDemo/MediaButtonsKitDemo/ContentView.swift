//
//  ContentView.swift
//  MediaButtonsKitDemo
//
//  Created by Bartlomiej Lanczyk on 22/10/2024.
//

import SwiftUI
import MediaButtonsKit

@Observable
class MockPhotoItem: PhotoItem {
    var imageData: Data?
}

struct ContentView: View {
    
    @State var mockImage = MockPhotoItem()
    @State var isSheetFirstPresented = false
    @State var isSheetSecondPresented = false
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                imageView
                
                Section("Default Camera") {
                    CameraButton(item: mockImage)
                }
                Section("Default Camera with useUserPreferredCamera") {
                    CameraButton(item: mockImage, useUserPreferredCamera: true)
                }
                Section("Camera with dismiss button") {
                    CameraButton(item: mockImage, leadingButton: .dismiss)
                }
                Section("Photo & Galery & dismiss button") {
                    Button {
                        isSheetFirstPresented = true
                    } label: {
                        Text("Show sheet")
                            .bold()
                    }
                }
                Section("Photo & Galery Button") {
                    Button {
                        isSheetSecondPresented = true
                    } label: {
                        Text("Show sheet")
                            .bold()
                    }
                }
            }
            .sheet(isPresented: $isSheetFirstPresented) {
                HStack {
                    CameraButton(item: mockImage, leadingButton: .dismiss, showImageSnapshotSheet: true, saveInLibrary: false)
                    GalleryButton(item: mockImage)
                }
                .padding()
                .presentationDetents([.height(200)])
            }
            .sheet(isPresented: $isSheetSecondPresented) {
                HStack {
                    CameraButton(item: mockImage)
                    GalleryButton(item: mockImage)
                }
                .padding()
                .presentationDetents([.height(200)])
            }
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        HStack {
            Spacer()
            if let data = mockImage.imageData {
                Image(uiImage: UIImage(data: data)!)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
            } else {
                Text("Selected Image")
            }
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
