 ![logo](https://github.com/user-attachments/assets/f9a67845-45bb-432e-b629-ff15635ab2a7) 
 # MediaButtonsKit

MediaButtonsKit is a lightweight and easy-to-use SwiftUI library that lets you quickly add camera and photo gallery buttons to your app – no boilerplate code required!

✨ Features

- 📷 Plug-and-play camera buttons
- 🖼️ Photo gallery buttons with full customization support
- 🎯 User preferences support (useUserPreferredCamera)
- ✅ Easily embeddable in sheets, forms, stacks, and more
- 🎨 Customizable look and toolbar actions

Add MediaButtonsKit to your project using Swift Package Manager:

```
https://github.com/miltenkot/MediaButtonsKit.git
```

# 🚀 Quick Start

```
import SwiftUI
import MediaButtonsKit

@Observable
class MockPhotoItem: PhotoItem {
    var imageData: Data?
}

struct ContentView: View {
    @State var mockImage = MockPhotoItem()
    @State var isCameraPresented = false
    
    var body: some View {
        CameraButton(item: mockImage,
                     isCameraPresented: $isCameraPresented)
    }
}
```
# 📋 Usage Examples

Camera configurations:
```
Section("Default Camera") {
    CameraButton(item: mockImage, isCameraPresented: $isFirstCameraPresented)
}

Section("Using user preferred camera") {
    CameraButton(item: mockImage, useUserPreferredCamera: true, isCameraPresented: $isSecondCameraPresented)
}

Section("Camera with dismiss button") {
    CameraButton(item: mockImage, leadingButton: .dismiss, isCameraPresented: $isThirdCameraPresented)
}
```

📦 Requirements

iOS 18+
Swift 6
SwiftUI
📮 Feedback & Contribution

Found a bug, have a feature request, or want to contribute?
Feel free to open an issue or send a pull request!

Let me know if you want a badge section at the top (like SwiftPM, iOS Compatible, etc.) or if you need help generating project documentation with DocC!
