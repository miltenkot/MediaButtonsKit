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
    
    @State var isGalleryPresented = false
    @State var isCameraPresented = false
    
    var body: some View {
        NavigationStack {
            Form {
                
                imageView
                
                Section("Default Camera") {
                    CameraButton(item: mockImage, isCameraPresented: $isCameraPresented)
                }
                Section("Default Camera with useUserPreferredCamera") {
                    CameraButton(item: mockImage, useUserPreferredCamera: true, isCameraPresented: $isCameraPresented)
                }
                Section("Camera with dismiss button") {
                    CameraButton(item: mockImage, leadingButton: .dismiss, isCameraPresented: $isCameraPresented)
                }
                Section("Photo & Galery & dismiss button") {
                    Button {
                        isSheetFirstPresented = true
                    } label: {
                        Text("Show sheet")
                            .bold()
                    }
                }
                Section("Photo & Custom Galery Button") {
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
                    CameraButton(item: mockImage, leadingButton: .dismiss, showImageSnapshotSheet: true, saveInLibrary: false, isCameraPresented: $isCameraPresented)
                    GalleryButton(item: mockImage, toolbarItemContent: {
                        Button("", systemImage: "xmark") {
                            isGalleryPresented = false
                        }
                    }, isGalleryPresented: $isGalleryPresented)
                }
                .padding()
                .presentationDetents([.height(200)])
            }
            .sheet(isPresented: $isSheetSecondPresented) {
                HStack {
                    CameraButton(item: mockImage, isCameraPresented: $isCameraPresented)
                    GalleryButton(item: mockImage, label: {
                        Text("Galery")
                            .bold()
                    }, toolbarItemContent: {
                        Button {
                            isGalleryPresented = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .fontDesign(.rounded)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.gray)
                        }
                    },
                                  toolbarItemPlacement: .topBarTrailing,
                                  isGalleryPresented: $isGalleryPresented)
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
