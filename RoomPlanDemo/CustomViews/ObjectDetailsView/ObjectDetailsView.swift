//
//  ObjectDetailsView.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 24.01.2025.
//

import SwiftUI
import RoomPlan

struct ObjectDetailsView: View {
    @Binding var object: FloorPlanObject?
    @Binding var selectedType: DetailsType?
    
    @State private var angle: CGFloat = 0
    
    init(object: Binding<FloorPlanObject?>,
         selectedType: Binding<DetailsType?>) {
        _object = object
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
            
            Spacer()
        }
        .background(Color.teal)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            if let object {
                // Convert radians to degrees
                let rotationInDegrees = object.zRotation * (180 / .pi)
                
                // Snap the angle to the nearest 15 degrees
                let snappedAngle = round(rotationInDegrees / 15) * 15
                
                // Normalize the angle to keep it within 0–360 degrees
                let normalizedAngle = snappedAngle.truncatingRemainder(dividingBy: 360)
                
                angle = normalizedAngle
            }
        }
    }
}

// MARK: Views
private extension ObjectDetailsView {
    var headerView: some View {
        HStack {
            createTitleView(from: object)
            
            Spacer()
            
            Button {
                withAnimation {
                    selectedType = nil
                    object?.deselect()
                    object = nil
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
    func createTitleView(from surface: FloorPlanObject?) -> some View {
        if let object {
            let objectCategory = object.capturedObject.category
            
            Text("\(objectCategory.displayName)")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
    }
    
    @ViewBuilder
    func createSliderButton(for type: DetailsType) -> some View {
        if let object {
            switch type {
            case .measurements, .doorDirection:
                EmptyView()
            case .delete:
                Button {
                    withAnimation {
                        object.removeFromParent()
                        selectedType = nil
                        object.deselect()
                        self.object = nil
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
                        object.updateAngle(to: normalizedAngle)
                        
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
}

#Preview {
    ObjectDetailsView(object: .constant(nil),
                      selectedType: .constant(.measurements))
}
