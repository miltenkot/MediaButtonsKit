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
    
    enum ActiveSheet: Identifiable {
        var id: Self { self }
        case first, second
    }
    
    @State var mockImage = MockPhotoItem()
    @State private var activeSheet: ActiveSheet?
    
    @State var isGalleryPresented = false
    @State var isFirstCameraPresented = false
    @State var isSecondCameraPresented = false
    @State var isThirdCameraPresented = false
    @State var isFourthCameraPresented = false
    @State var isFifthCameraPresented = false
    
    var body: some View {
        NavigationStack {
            Form {
                imageView
                
                Section("Default Camera") {
                    CameraButton(item: mockImage,
                                 isCameraPresented: $isFirstCameraPresented)
                }
                Section("Default Camera with useUserPreferredCamera") {
                    CameraButton(item: mockImage,
                                 useUserPreferredCamera: true,
                                 isCameraPresented: $isSecondCameraPresented)
                }
                Section("Camera with dismiss button") {
                    CameraButton(item: mockImage,
                                 leadingButton: .dismiss,
                                 isCameraPresented: $isThirdCameraPresented)
                }
                Section("Photo & Galery & dismiss button") {
                    Button {
                        activeSheet = .first
                    } label: {
                        Text("Show sheet")
                            .bold()
                    }
                }
                Section("Photo & Custom Galery Button") {
                    Button {
                        activeSheet = .second
                    } label: {
                        Text("Show sheet")
                            .bold()
                    }
                }
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                case .first: firstSheet
                case .second: secondSheet
                }
            }
        }
    }
    
    @ViewBuilder
    private var firstSheet: some View {
        HStack {
            CameraButton(item: mockImage, leadingButton: .dismiss, showImageSnapshotSheet: true, saveInLibrary: false, isCameraPresented: $isFourthCameraPresented)
            GalleryButton(item: mockImage, toolbarItemContent: {
                Button("", systemImage: "xmark") {
                    isGalleryPresented = false
                }
            }, isGalleryPresented: $isGalleryPresented)
        }
        .padding()
        .presentationDetents([.height(200)])
    }
    @ViewBuilder
    private var secondSheet: some View {
        HStack {
            CameraButton(item: mockImage, isCameraPresented: $isFifthCameraPresented)
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

#if DEBUG
#Preview {
    ContentView()
}
#endif
