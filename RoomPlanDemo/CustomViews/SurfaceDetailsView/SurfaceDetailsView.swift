//
//  SurfaceDetailsView.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 15.01.2025.
//

import SwiftUI
import RoomPlan

struct SurfaceDetailsView: View {
    @Binding var surface: FloorPlanSurface?
    @Binding var selectedType: DetailsType?
    
    @State private var angle: CGFloat = 0
    @State private var width: CGFloat = 0
    @State private var depth: CGFloat = 0
    @State private var position: CGPoint = .init(x: 0, y: 0)
    @State private var zPosition: CGFloat = 0
    @State private var selectedDirection: OpenDirection = .clockwise
    
    init(surface: Binding<FloorPlanSurface?>,
         selectedType: Binding<DetailsType?>) {
        _surface = surface
        _selectedType = selectedType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    headerView
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(DetailsType.allCases, id: \.self) { type in
                                createSliderButton(for: type)
                            }
                        }
                    }
                }
                .padding(20)
            }
            
            ScrollView(.vertical) {
                if let selectedType {
                    createDetailsContent(for: selectedType)
                }
            }
            
            Spacer()
        }
        .background(Color.teal)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            if let surface {
                // Convert radians to degrees
                let rotationInDegrees = surface.zRotation * (180 / .pi)
                
                // Snap the angle to the nearest 15 degrees
                let snappedAngle = round(rotationInDegrees / 15) * 15
                
                // Normalize the angle to keep it within 0–360 degrees
                let normalizedAngle = snappedAngle.truncatingRemainder(dividingBy: 360)
                
                angle = normalizedAngle
                
                width = surface.halfLength * 2
                depth = surface.selectedShape?.lineWidth ?? 0
                position = surface.position
                zPosition = surface.zPosition
                selectedDirection = surface.openDirection
            }
        }
    }
}

// MARK: Views
private extension SurfaceDetailsView {
    func getAllSliderMesurementTypes() -> [SliderMesurementType] {
        return [.angle(angle), .width(width), .depth(depth), .xPosition(position.x), .yPosition(position.y), .zPosition(zPosition)]
    }
    
    var headerView: some View {
        HStack {
            createTitleView(from: surface)
            
            Spacer()
            
            Button {
                withAnimation {
                    selectedType = nil
                    surface?.deselect()
                    surface = nil
                }
            } label: {
                Image(systemName: "xmark.square.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.white)
            }
        }
    }
    
    @ViewBuilder
    func createTitleView(from surface: FloorPlanSurface?) -> some View {
        if let surface {
            let surfaceCategory = surface.capturedSurface.category
            
            Text("\(getSurfaceName(for: surfaceCategory))")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
    }
    
    func getSurfaceName(for type: CapturedRoom.Surface.Category) -> String {
        switch type {
        case .door:
            "The Door"
        case .wall:
            "The Wall"
        case .opening:
            "The Opening"
        case .window:
            "The Window"
        case .floor:
            "The Floor"
        @unknown default:
            "Unknown Surface"
        }
    }
    
    @ViewBuilder
    func createSliderButton(for type: DetailsType) -> some View {
        if let surface {
            switch type {
            case .measurements:
                switch surface.capturedSurface.category {
                case .wall, .window, .door:
                    Button {
                        withAnimation {
                            selectedType = type
                        }
                    } label: {
                        VStack {
                            Image(systemName: type.buttonImageName)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                            
                            Text(type.description)
                                .foregroundStyle(.white)
                        }
                    }
                case .opening, .floor:
                    EmptyView()
                @unknown default: EmptyView()
                }
            case .doorDirection:
                switch surface.capturedSurface.category {
                case .window, .door:
                    Button {
                        withAnimation {
                            selectedType = type
                        }
                    } label: {
                        VStack {
                            Image(systemName: type.buttonImageName)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                            
                            Text(type.description)
                                .foregroundStyle(.white)
                        }
                    }
                case .opening, .floor, .wall:
                    EmptyView()
                @unknown default: EmptyView()
                }
            case .delete:
                Button {
                    withAnimation {
                        surface.removeFromParent()
                        selectedType = nil
                        surface.deselect()
                        self.surface = nil
                    }
                } label: {
                    VStack {
                        Image(systemName: type.buttonImageName)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                        
                        Text(type.description)
                            .foregroundStyle(.white)
                    }
                }
            case .rotate:
                Button {
                    withAnimation {
                        
                        // Increment the angle by 15 degrees
                        let incrementedAngle = angle + 10
                        
                        // Snap the angle to the nearest 15 degrees (although this may not be necessary since increments are already 15)
                        let snappedAngle = round(incrementedAngle / 15) * 15
                        
                        // Normalize the angle to keep it within 0–360 degrees
                        let normalizedAngle = snappedAngle.truncatingRemainder(dividingBy: 360)
                        
                        // Update the annotation's angle
                        surface.updateAngleRadians(to: normalizedAngle)
                        
                        // Update the local angle variable
                        angle = normalizedAngle
                    }
                } label: {
                    VStack {
                        Image(systemName: type.buttonImageName)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
                        
                        Text(type.description)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
    
    func createDetailsContent(for type: DetailsType) -> some View {
        VStack {
            switch type {
            case .measurements:
                AdjustMesurementView(
                    sliderBinding: Binding(
                        get: {
                            surface?.zRotation ?? 0
                        },
                        set: { newValue in
                            surface?.updateAngle(to: newValue)
                            angle = newValue
                        }),
                    sliderType: .angle(angle),
                    newPosition: .constant(""))
                
                AdjustMesurementView(
                    sliderBinding: Binding(
                        get: {
                            surface?.halfLength ?? 0 * 2
                        },
                        set: { newValue in
                            surface?.updateWidth(to: newValue)
                            width = newValue
                        }),
                    sliderType: .width(width),
                    newPosition: .constant(""))
                
                
                AdjustMesurementView(
                    sliderBinding: Binding(
                        get: {
                            surface?.selectedShape?.lineWidth ?? 0
                        },
                        set: { newValue in
                            surface?.updateDepth(to: newValue)
                            depth = newValue
                        }),
                    sliderType: .depth(depth),
                    newPosition: .constant(""))
                
                AdjustMesurementView(
                    sliderBinding: nil,
                    sliderType: .xPosition(position.x),
                    newPosition: Binding(
                        get: {
                            String(format: "%.2f", Float(surface?.position.x ?? 0))
                        },
                        set: { newValue in
                            if let newValueAsFloat = Float(newValue) {
                                surface?.updatePosition(x: CGFloat(newValueAsFloat))
                                position.x = CGFloat(newValueAsFloat)
                            }
                        }
                    )
                )
                
                AdjustMesurementView(
                    sliderBinding: nil,
                    sliderType: .yPosition(position.y),
                    newPosition: Binding(
                        get: {
                            String(format: "%.2f", Float(surface?.position.y ?? 0))
                        },
                        set: { newValue in
                            if let newValueAsFloat = Float(newValue) {
                                surface?.updatePosition(y: CGFloat(newValueAsFloat))
                                position.y = CGFloat(newValueAsFloat)
                            }
                        }
                    )
                )
                
                AdjustMesurementView(
                    sliderBinding: nil,
                    sliderType: .zPosition(zPosition),
                    newPosition: Binding(
                        get: {
                            String(format: "%.2f", Float(surface?.zPosition ?? 0))
                        },
                        set: { newValue in
                            if let newValueAsFloat = Float(newValue) {
                                surface?.updatePosition(z: CGFloat(newValueAsFloat))
                                zPosition = CGFloat(newValueAsFloat)
                            }
                        }
                    )
                )
            case .doorDirection:
                HStack {
                    Text("Direction:")
                        .font(.body)
                    
                    Spacer()
                    
                    Picker("Direction", selection: Binding(
                        get: {
                            selectedDirection
                        },
                        set: { newValue in
                            surface?.updateDoorOpenDirection(to: newValue)
                            selectedDirection = newValue
                        }
                    )) {
                        ForEach(OpenDirection.allCases, id: \.self) { direction in
                            Text(direction.description)
                                .tag(direction)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal, 20)
            case .delete, .rotate:
                EmptyView()
            }
        }
    }
}

#Preview {
    // Create a mock data manager
    let mockDataManager = MockDataManager()
    
    // Load a captured room safely
    let capturedRoom = mockDataManager.loadCapturedRoom()
    
    // Load a surface safely
    let surface = capturedRoom?.walls.first
    let floorPlanSurface = FloorPlanSurface(capturedSurface: surface!)
    
    // Provide the surface as a binding
    SurfaceDetailsView(surface: .constant(floorPlanSurface),
                       selectedType: .constant(nil))
}
