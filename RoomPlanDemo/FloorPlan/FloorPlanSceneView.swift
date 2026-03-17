//
//  FloorPlanSceneView.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 26.01.2025.
//

import SwiftUI
import SpriteKit
import RoomPlan

struct FloorPlanSceneView: UIViewRepresentable {
    private let capturedRoom: CapturedRoom
    @ObservedObject var viewModel: FloorPlanViewModel
    
    init(capturedRoom: CapturedRoom,
         viewModel: FloorPlanViewModel) {
        self.capturedRoom = capturedRoom
        self.viewModel = viewModel
    }
    
    func makeUIView(context: Context) -> SKView {
        cretateFloorPlanView()
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Update the scene with new data if necessary
        handleViewUpdates(uiView)
    }
}

// MARK: Private methods
private extension FloorPlanSceneView {
    func cretateFloorPlanView() -> SKView {
        let skView = SKView()
        
        // Create FloorPlanScene with the capturedRoom and viewModel
        let scene = FloorPlanScene(capturedRoom: capturedRoom,
                                   viewModel: viewModel)
        
        // Set the scene and other properties
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        return skView
    }
    
    func handleViewUpdates(_ uiView: SKView) {
        guard let scene = uiView.scene as? FloorPlanScene else { return }
        
        if let selectedFurniture = viewModel.furnitureToAdd {
            DispatchQueue.main.async {
                scene.addNewObject(with: selectedFurniture)
            }
        }
        
        if viewModel.shouldAddText {
            DispatchQueue.main.async {
                scene.addExampleAnnotations()
                viewModel.shouldAddText = false
            }
        }
        
        if let shareType = viewModel.shareFormat {
            DispatchQueue.main.async {
                scene.exportImage(with: shareType)
                viewModel.shareFormat = nil
            }
        }
    }
}
