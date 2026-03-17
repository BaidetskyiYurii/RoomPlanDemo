# 🏠 RoomPlanDemo — LiDAR Room Scanner & 2D Floor Plan

> An iOS demo app that uses Apple's **RoomPlan framework** to scan a room with LiDAR and instantly generate an interactive 2D floor plan — with furniture editing, annotations, and USDZ export.

![Platform](https://img.shields.io/badge/Platform-iOS%2016%2B-blue?style=flat)
![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=flat)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI%20%2B%20UIKit-purple?style=flat)
![RoomPlan](https://img.shields.io/badge/Framework-RoomPlan-black?style=flat)
![LiDAR](https://img.shields.io/badge/Hardware-LiDAR%20Required-red?style=flat)

---

## 📱 What It Does

RoomPlanDemo uses Apple's **RoomPlan framework** to capture a room's geometry via the LiDAR scanner, then converts the scan result into a fully interactive 2D floor plan rendered with **SpriteKit**. Users can tap walls, doors, windows, and objects to inspect details, add custom furniture, drop annotations, and export the floor plan as PNG, JPEG, or PDF.

A **Demo Mode** is included so the app can be explored on any device using pre-loaded mock room data — no LiDAR required.

---

## ✨ Features

**Scanning**
- Live room capture using `RoomCaptureView` and `RoomCaptureSession`
- `RoomCaptureSessionDelegate` for real-time capture events
- `RoomBuilder` with `.beautifyObjects` post-processing
- Prevents screen sleep during active scan (`isIdleTimerDisabled`)

**2D Floor Plan — SpriteKit**
- Walls, doors, windows, and openings rendered as `SKShapeNode` elements
- Detected objects (furniture, appliances) drawn as labeled nodes
- Pan, pinch-to-zoom, and two-finger rotation gesture support
- Camera movement respects current rotation angle (rotation-aware pan translation)
- Tap to select surfaces, objects, or annotations individually

**Editing**
- Tap any wall or surface → bottom sheet with surface details and type editing
- Tap any object → bottom sheet with object details and category editing
- Add custom furniture from all `CapturedRoom.Object.Category` types
- Drag furniture and annotation nodes freely across the floor plan
- Add text annotations with custom title, subtitle, font, and color

**Export**
- Export floor plan as PNG, JPEG, or PDF via `UIActivityViewController`
- Export full 3D scan as `.usdz` file for use in AR Quick Look or other tools

**Demo Mode**
- Launch with pre-loaded `CapturedRoom` mock data — no LiDAR device needed
- Full floor plan interaction available in demo

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|------------|
| Room Scanning | `RoomPlan` — `RoomCaptureView`, `RoomCaptureSession`, `RoomBuilder` |
| 2D Rendering | `SpriteKit` — `SKScene`, `SKShapeNode`, `SKCameraNode` |
| UI Framework | SwiftUI + UIKit (`UIViewRepresentable` bridge) |
| 3D Export | `RoomPlan` USDZ export via `CapturedRoom.export(to:)` |
| Image Export | `UIGraphicsPDFRenderer`, `UIActivityViewController` |
| Gesture Handling | `UIPanGestureRecognizer`, `UIPinchGestureRecognizer`, `UIRotationGestureRecognizer` |
| State Management | `@ObservableObject` / `@Published` |
| Hardware | LiDAR Scanner (iPhone 12 Pro+, iPad Pro 2020+) |
| Min Deployment | iOS 16.0 |

---

## 🏗 Project Structure

```
RoomPlanDemo/
├── RoomCapture/
│   ├── RoomCaptureViewModel.swift     # RoomCaptureSession + RoomBuilder logic
│   ├── RoomCaptureRepresentable.swift # UIViewRepresentable bridge for RoomCaptureView
│   └── RoomCaptureScanView.swift      # Main scan/floor plan coordinator view
├── FloorPlan/
│   ├── FloorPlanScene.swift           # SKScene — renders walls, objects, handles gestures
│   ├── FloorPlanSceneView.swift       # SwiftUI wrapper for SKScene
│   ├── FloorPlanSurface.swift         # SKShapeNode subclass for surfaces
│   ├── FloorPlanObject.swift          # SKShapeNode subclass for furniture/objects
│   ├── FloorPlanAnnotation.swift      # SKNode subclass for text annotations
│   ├── FloorPlanViewModel.swift       # Selection state and editing flags
│   └── DrawParameters.swift          # Scene sizing and drawing constants
├── CustomViews/
│   ├── AddFurnitureView/              # Horizontal furniture picker sheet
│   ├── ObjectDetailsView/            # Object type editing bottom sheet
│   ├── SurfaceDetailsView/           # Surface type editing bottom sheet
│   ├── AnnotationsDetailsView/       # Annotation editing bottom sheet
│   ├── AdjustMesurementView/         # Measurement adjustment UI
│   ├── RoomOptionsView/              # Toolbar options (add furniture, export, etc.)
│   └── ShareImageView/               # Export format selector sheet
├── Models/
│   ├── DetailsType.swift
│   ├── ImageFormat.swift             # PNG / JPEG / PDF
│   ├── OpenDirection.swift
│   ├── RoomOptionType.swift
│   └── SliderMesurementType.swift
├── Extensions/
│   ├── CapturedRoom+Extensions.swift
│   ├── CGFloat+Extensions.swift
│   ├── CGMutablePath+Extensions.swift
│   ├── CGPoint+Extensions.swift
│   ├── SKShapeNode+Extensions.swift
│   └── simd_float4x4+Extensions.swift # LiDAR transform matrix helpers
├── MockDataManager.swift              # Pre-loaded room data for Demo Mode
└── WelcomeView.swift                  # Entry point with Scan / Demo options
```

---

## 🚀 Getting Started

### Requirements
- Xcode 15+
- iOS 16.0+
- **LiDAR-equipped device** for live scanning: iPhone 12 Pro or later, iPad Pro (2020) or later
- Swift 5.9+

### Setup
```bash
git clone https://github.com/BaidetskyiYurii/RoomPlanDemo.git
cd RoomPlanDemo
open RoomPlanDemo/RoomPlanDemo.xcodeproj
```

> **No LiDAR device?** Tap **"Try Demo"** on the welcome screen to explore the full floor plan experience with pre-loaded mock room data.

---

## 🔑 Key Implementation Details

### RoomPlan Integration
```swift
// Session setup with delegate
roomCaptureView = RoomCaptureView(frame: .zero)
roomBuilder = RoomBuilder(options: [.beautifyObjects])
roomCaptureView.captureSession.delegate = self

// Process captured data
let room = try await roomBuilder.capturedRoom(from: data)
```

### SwiftUI ↔ UIKit Bridge
`RoomCaptureView` is a UIKit view — bridged to SwiftUI via `UIViewRepresentable`:
```swift
struct RoomCaptureRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> RoomCaptureView { roomCaptureView }
    func updateUIView(_ uiView: RoomCaptureView, context: Context) {}
}
```

### Rotation-Aware Camera Pan
Pan translation is transformed by the camera's current rotation angle to keep movement aligned with the visual orientation of the floor plan:
```swift
let rotatedTranslation = CGPoint(
    x: translation.x * cos(rotationAngle) - translation.y * sin(rotationAngle),
    y: translation.x * sin(rotationAngle) + translation.y * cos(rotationAngle)
)
```

---

## 💡 Why This Project

RoomPlan is one of Apple's more specialized frameworks — most iOS engineers haven't worked with it. This demo shows how to bridge a LiDAR capture session into a fully interactive 2D editor, handling the coordinate system translation from 3D `simd_float4x4` transforms to 2D SpriteKit scene coordinates, gesture interaction with individual nodes, and file export in multiple formats. It was built as a practical exploration of what's possible with spatial computing on iPhone.

---

## 👨‍💻 Author

**Yurii Baidetskyi** — iOS Engineer  
[LinkedIn](https://linkedin.com/in/yuriibaidetskyi) · [GitHub](https://github.com/BaidetskyiYurii)
