//
//  FloorPlanScene.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 08.01.2025.
//

import RoomPlan
import SpriteKit
import RealityKit
import SwiftUI

final class FloorPlanScene: SKScene {
    
    // MARK: - Properties
    let viewModel: FloorPlanViewModel
    // Variables that store camera scale and position at the start of a gesture
    private var previousCameraScale = CGFloat()
    private var previousCameraPosition = CGPoint()
    
    // Surfaces and objects from our scan result
    private let surfaces: [CapturedRoom.Surface]
    private let objects: [CapturedRoom.Object]
    
    private let capturedRoom: CapturedRoom
    
    // MARK: - Init
    init(capturedRoom: CapturedRoom, viewModel: FloorPlanViewModel) {
        self.capturedRoom = capturedRoom
        self.surfaces = capturedRoom.doors + capturedRoom.openings + capturedRoom.walls + capturedRoom.windows
        self.objects = capturedRoom.objects
        self.viewModel = viewModel
        
        super.init(size: DrawParameters.floorPlanSize)
        
        self.scaleMode = .aspectFill
        self.anchorPoint = DrawParameters.floorPlanAnchorPoint
        self.backgroundColor = DrawParameters.floorPlanBackgroundColor
        
        addCamera()
        drawSurfaces()
        drawObjects()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer()
        pinchGestureRecognizer.addTarget(self, action: #selector(pinchGestureAction(_:)))
        view.addGestureRecognizer(pinchGestureRecognizer)
        
        // Gesture to rotate camera
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotationGestureAction(_:)))
        view.addGestureRecognizer(rotationGestureRecognizer)
    }
}

// MARK: UI Methods
private extension FloorPlanScene {
    // MARK: - Draw
    func drawSurfaces() {
        for surface in surfaces {
            let surfaceNode = FloorPlanSurface(capturedSurface: surface)
            addChild(surfaceNode)
        }
    }
    
    func drawObjects() {
        for object in objects {
            let objectNode = FloorPlanObject(capturedObject: object)
            addChild(objectNode)
        }
    }
    
    // MARK: - Surface Selection Handling
    func selectSurface(_ surfaceNode: FloorPlanSurface) {
        // Deselect previously selected surface
        deselectSurface()
        
        // Update the appearance of the selected surface
        surfaceNode.select()
        // Track the selected surface
        
        viewModel.selectedSurface = surfaceNode
    }
    
    func deselectSurface() {
        // Remove highlight from the previously selected surface
        viewModel.selectedSurface?.deselect()
        viewModel.selectedSurface = nil
    }
    
    // MARK: - Object Selection Handling
    func selectObject(_ objectNode: FloorPlanObject) {
        // Deselect previously selected surface
        deselectObject()
        
        // Update the appearance of the selected surface
        objectNode.select()
        // Track the selected surface
        
        viewModel.selectedObject = objectNode
    }
    
    func deselectObject() {
        // Remove highlight from the previously selected surface
        viewModel.selectedObject?.deselect()
        viewModel.selectedObject = nil
    }
    
    // MARK: - Annotation Selection Handling
    func selectAnnotation(_ annotationNode: FloorPlanAnnotation) {
        deselectAnnotation()
        
        annotationNode.highlight()
        // Track the selected surface
        
        viewModel.selectedAnnotation = annotationNode
    }
    
    func deselectAnnotation() {
        // Remove highlight from the previously selected surface
        viewModel.selectedAnnotation?.removeHighlight()
        viewModel.selectedAnnotation = nil
    }
}

// MARK: Actions
private extension FloorPlanScene {
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        // Convert the touch location in the view to the scene's coordinate system
        let locationInView = sender.location(in: view)
        let locationInScene = convertPoint(fromView: locationInView)
        
        if let selectedObject = viewModel.selectedObject {
            // Check if the touch is within the bounds of the selected object
            if selectedObject.contains(locationInScene) {
                // Handle object dragging
                switch sender.state {
                case .changed:
                    selectedObject.position = locationInScene
                default:
                    break
                }
                return // Prevent camera movement if object interaction occurs
            }
        }
        
        if let annotationNode = viewModel.selectedAnnotation {
            if annotationNode.contains(locationInScene) {
                // Handle object dragging
                switch sender.state {
                case .changed:
                    annotationNode.position = locationInScene
                default:
                    break
                }
                return // Prevent camera movement if object interaction occurs
            }
        }
        
        // Handle camera movement if no object interaction occurs
        guard let camera = self.camera else { return }
        
        switch sender.state {
        case .began:
            // Save the camera's initial position
            previousCameraPosition = camera.position
            
        case .changed:
            // Get the translation from the gesture recognizer
            let translation = sender.translation(in: self.view)
            
            // Get the camera's current rotation angle (in radians)
            let rotationAngle = -camera.zRotation // Negative to align with rotation direction
            
            // Apply the rotation to the translation vector
            let rotatedTranslation = CGPoint(
                x: translation.x * cos(rotationAngle) - translation.y * sin(rotationAngle),
                y: translation.x * sin(rotationAngle) + translation.y * cos(rotationAngle)
            )
            
            // Scale the translation based on the camera's zoom level
            let translationScale = camera.xScale
            
            // Update the camera's position
            let newCameraPosition = CGPoint(
                x: previousCameraPosition.x - rotatedTranslation.x * translationScale,
                y: previousCameraPosition.y - -rotatedTranslation.y * translationScale
            )
            camera.position = newCameraPosition
        default:
            break
        }
    }
    
    // Pinch gestures only handle camera movement in this scene
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else { return }
        
        if sender.state == .began {
            previousCameraScale = camera.xScale
        }
        
        camera.setScale(previousCameraScale * 1 / sender.scale)
    }
    
    @objc func rotationGestureAction(_ sender: UIRotationGestureRecognizer) {
        guard let camera = self.camera else { return }
        
        if sender.state == .began || sender.state == .changed {
            camera.zRotation += sender.rotation
            sender.rotation = 0 // Reset the rotation to avoid compounding
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        let locationInView = gesture.location(in: view)
        let locationInScene = convertPoint(fromView: locationInView)
        
        // Check if the tap is on a surface nodeCannot
        if let surfaceNode = nodes(at: locationInScene).compactMap({ $0 as? FloorPlanSurface }).first {
            deselectObject()
            deselectAnnotation()
            selectSurface(surfaceNode)
        } else {
            // Deselect the currently selected surface if tapped elsewhere
            deselectSurface()
        }
        
        if let objectNode = nodes(at: locationInScene).compactMap({ $0 as? FloorPlanObject }).first {
            deselectSurface()
            deselectAnnotation()
            selectObject(objectNode)
            
        } else {
            // Deselect the currently selected surface if tapped elsewhere
            deselectObject()
        }
        
        if let annotationNode = nodes(at: locationInScene).compactMap({ $0 as? FloorPlanAnnotation }).first {
            deselectSurface()
            deselectObject()
            selectAnnotation(annotationNode)
        } else {
            // Deselect the currently selected surface if tapped elsewhere
            deselectAnnotation()
        }
    }
}

// MARK:  - Camera
private extension FloorPlanScene {
    func addCamera() {
        let cameraNode = SKCameraNode()
        addChild(cameraNode)
        self.camera = cameraNode
    }
}

// MARK: Public methods
extension FloorPlanScene {
    func addNewObject(with category: CapturedRoom.Object.Category) {
        guard let camera = self.camera else {
            print("Camera not available")
            return
        }
        
        // Convert the camera's position to scene's coordinates (camera.position is in camera's coordinate system)
        let cameraPosition = camera.position
        
        // Use the position as the center for the new object
        let newObjectPosition = CGPoint(x: cameraPosition.x, y: cameraPosition.y)
        // Create a new object at the center of the floor
        guard let firstObject = objects.first else {
            print("No objects to add")
            return
        }
        
        let newFloorPlanObject = FloorPlanObject(
            capturedObject: firstObject,
            withCategory: category,
            objectPosition: newObjectPosition
        )
        
        // Add the object to the scene
        addChild(newFloorPlanObject)
    }
    
    func addExampleAnnotations() {
        guard let camera = self.camera else {
            print("Camera not available")
            return
        }
        
        // Convert the camera's position to scene's coordinates (camera.position is in camera's coordinate system)
        let cameraPosition = camera.position
        
        let newObjectPosition = CGPoint(x: cameraPosition.x,
                                        y: cameraPosition.y)
        
        let annotation = FloorPlanAnnotation(
            title: "Main Hall",
            subtitle: "Ground Floor",
            fontSize: 40,
            fontColor: .blue)
        
        annotation.position = newObjectPosition
        addChild(annotation)
    }
}

// MARK: Public export image methods
extension FloorPlanScene {
    func exportImage(with format: ImageFormat) {
        // Get the snapshot image of the scene
        guard let snapshot = snapshot() else {
            print("Error: Failed to capture the snapshot.")
            return
        }
        
        // Prepare the image data based on selected format
        var imageData: Data?
        
        switch format {
        case .png:
            imageData = snapshot.pngData()
        case .jpeg:
            imageData = snapshot.jpegData(compressionQuality: 1.0) // Full quality for JPEG
        case .pdf:
            // Create a PDF document from the image
            let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: snapshot.size))
            imageData = pdfRenderer.pdfData { context in
                context.beginPage()
                snapshot.draw(in: CGRect(origin: .zero, size: snapshot.size))
            }
        }
        
        // Save the image data to a file
        guard let data = imageData else {
            print("Error: Failed to convert image to data")
            return
        }
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent("floorPlan.\(format.rawValue)")
        
        do {
            try data.write(to: fileURL)
            print("Image saved to: \(fileURL)")
            // Assuming `presentShareSheet(with:)` exists to present the share sheet
            presentShareSheet(with: fileURL)
        } catch {
            print("Error saving image: \(error.localizedDescription)")
        }
    }
}

// MARK: Private export image methods
extension FloorPlanScene {
    func presentShareSheet(with fileURL: URL) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("Unable to find root view controller.")
            return
        }
        
        // Create a UIActivityViewController to share the file
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        
        // Present the activity view controller
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }
    
    func snapshot() -> UIImage? {
        // Ensure the view and scene have valid configurations
        guard let view = self.view else { return nil }
        
        // Define the crop rectangle as the full scene size
        let cropRect = CGRect(origin: .zero, size: self.size)
        
        // Create a texture from the entire scene using the crop rectangle
        guard let texture = view.texture(from: self, crop: cropRect) else {
            return nil
        }
        
        // Convert the texture into a UIImage
        let snapshot = UIImage(cgImage: texture.cgImage())
        
        return snapshot
    }
}
