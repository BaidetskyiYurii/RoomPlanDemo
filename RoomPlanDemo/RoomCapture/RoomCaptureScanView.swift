//
//  RoomCaptureScanView.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 08.01.2025.
//

import SwiftUI
import SpriteKit
import RoomPlan
import SceneKit

struct RoomCaptureScanView: View {
    // MARK: - Properties & State
    @StateObject private var viewModel: RoomCaptureViewModel = .init()
    @StateObject private var floorPlanViewModel = FloorPlanViewModel()
    @StateObject private var mockDataManager = MockDataManager()
    
    private let isDemo: Bool
    
    init(isDemo: Bool = false) {
        self.isDemo = isDemo
    }
    
    // MARK: - View Body
    var body: some View {
        ZStack {
            mainRoomView
            
            if floorPlanViewModel.selectedObject != nil {
                VStack {
                    Spacer()
                    
                    ObjectDetailsView(
                        object: $floorPlanViewModel.selectedObject,
                        selectedType: $floorPlanViewModel.selectedType)
                    .frame(height: 200)
                    .padding(.horizontal, 20)
                }
            }
            
            if viewModel.isShowingFloorPlan,
               floorPlanViewModel.selectedObject == nil, floorPlanViewModel.selectedSurface == nil {
                VStack {
                    Spacer()
                    
                    RoomOptionsView(
                        selectedOption: $floorPlanViewModel.roomOptionType,
                        shouldAddFurniture: $floorPlanViewModel.shouldAddFurniture,
                        shouldAddText: $floorPlanViewModel.shouldAddText,
                        shouldShareImage: $floorPlanViewModel.shouldShareImage)
                    .frame(height: 150)
                    .padding(.horizontal, 20)
                }
            }
            
            if floorPlanViewModel.selectedAnnotation != nil {
                VStack {
                    Spacer()
                    
                    AnnotationsDetailsView(selectedAnnotation: $floorPlanViewModel.selectedAnnotation)
                        .frame(height: 250)
                        .padding(.horizontal, 20)
                }
            }
        }
        .onAppear {
            // Start the scan session when the view appears
            // MARK: Real
            if !isDemo {
                viewModel.startSession()
            }
        }
        .sheet(item: $floorPlanViewModel.selectedSurface,
               content: { type in
            SurfaceDetailsView(
                surface: $floorPlanViewModel.selectedSurface,
                selectedType: $floorPlanViewModel.selectedType)
            .presentationDetents([.fraction(0.3), .medium])
            .interactiveDismissDisabled()
            .ignoresSafeArea()
        })
        .sheet(
            isPresented: Binding(
                get: {
                    floorPlanViewModel.roomOptionType == .exportImage
                },
                set: { newValue in
                    if !newValue {
                        floorPlanViewModel.roomOptionType = nil
                    }
                }
            ), content: {
                ShareImageView(
                    shouldShareImage: $floorPlanViewModel.shouldShareImage,
                    shareFormat: $floorPlanViewModel.shareFormat,
                    roomOptionType: $floorPlanViewModel.roomOptionType)
                .presentationDetents([.fraction(0.3)])
                .interactiveDismissDisabled()
                .ignoresSafeArea()
            })
        .sheet(isPresented: $floorPlanViewModel.shouldAddFurniture,
               onDismiss: {
            floorPlanViewModel.roomOptionType = nil
            floorPlanViewModel.furnitureToAdd = nil
        }, content: {
            AddFurnitureView(
                floorPlanViewModel: floorPlanViewModel)
            .presentationDetents([.fraction(0.4)])
            .interactiveDismissDisabled()
            .ignoresSafeArea()
        })
        .alert("Error", isPresented: $viewModel.isShowError, actions: {
            Button("OK", role: .cancel) {}
        }, message: {
            Text(viewModel.errorMessage)
        })
    }
}

// MARK: Views
private extension RoomCaptureScanView {
    
    @ViewBuilder
    var mainRoomView: some View {
        // MARK: Real
        if isDemo {
            // MARK: Demo
            if let finalRoom = mockDataManager.loadCapturedRoom() {
                FloorPlanSceneView(capturedRoom: finalRoom,
                                   viewModel: floorPlanViewModel)
                .ignoresSafeArea()
            }
        } else {
            if viewModel.isShowingFloorPlan,
               let finalRoom = viewModel.getFinalRoom() {
                FloorPlanSceneView(capturedRoom: finalRoom,
                                   viewModel: floorPlanViewModel)
                .ignoresSafeArea()
            } else {
                RoomCaptureRepresentable(roomCaptureView: viewModel.roomCaptureView)
                    .ignoresSafeArea()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            scanButtonView
                        }
                        
                        if !viewModel.isScanning {
                            ToolbarItem(placement: .topBarTrailing) {
                                shareButtonView
                            }
                        }
                    }
                
            }
        }
    }
    
    var scanButtonView: some View {
        let title = viewModel.isScanning ? "Finish Scanning" : "View 2D plan"
        return Button(action: {
            viewModel.handleScanButtonTap()
        }) {
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.regular)
                .padding(2)
                .padding(.horizontal, 5)
                .background(Color.red)
                .clipShape(Capsule())
        }
    }
    
    var shareButtonView: some View {
        // Share button
        Button(action: {
            viewModel.shareCapturedRoom()
        }) {
            Text("Share Room")
                .foregroundColor(.white)
                .padding(2)
                .padding(.horizontal, 5)
                .background(Color.green)
                .clipShape(Capsule())
                .fontWeight(.regular)
        }
    }
}

#Preview {
    RoomCaptureScanView()
}
