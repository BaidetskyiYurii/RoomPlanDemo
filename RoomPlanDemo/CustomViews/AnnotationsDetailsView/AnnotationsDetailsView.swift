//
//  AnnotationsDetailsView.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 26.01.2025.
//

import SwiftUI
import SpriteKit

struct AnnotationsDetailsView: View {
    @Binding private var selectedAnnotation: FloorPlanAnnotation?
    
    @State private var newTitle = ""
    @State private var isEditingTitle = false
    @State private var isEditingSubTitle = false
    @State private var angle: CGFloat = 0
    
    let mainActions: [DetailsType] = [.rotate, .delete]
    
    init(selectedAnnotation: Binding<FloorPlanAnnotation?>) {
        _selectedAnnotation = selectedAnnotation
    }
    
    var body: some View {
        VStack(spacing: 10) {
            headerView
            
            ScrollView {
                VStack(spacing: 10) {
                    mainActionButtonView
                    
                    updateColorView
                }
            }
            
            Spacer()
        }
        .padding(.all, 20)
        .background(Color.teal)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .alert("Edit Annotation Title", isPresented: $isEditingTitle, actions: {
            TextField("New Title", text: $newTitle)
            Button("Save") {
                selectedAnnotation?.updateTitle(newTitle)
            }
            Button("Cancel", role: .cancel) {}
        })
        .alert("Edit Annotation SubTitle", isPresented: $isEditingSubTitle, actions: {
            TextField("New SubTitle", text: $newTitle)
            Button("Save") {
                selectedAnnotation?.updateSubTitle(newTitle)
            }
            Button("Cancel", role: .cancel) {}
        })
        .onAppear {
            if let selectedAnnotation {
                angle = selectedAnnotation.zRotation
            }
        }
    }
}

// MARK: Views
private extension AnnotationsDetailsView {
    func editLabelView(isEditingTitleLabel: Bool) -> some View {
        Button {
            withAnimation {
                editAnnotation(isEditingTitleLabel: isEditingTitleLabel)
            }
        } label: {
            HStack {
                let labelText = isEditingTitleLabel ? selectedAnnotation?.titleLabel.text : selectedAnnotation?.subtitleLabel.text
                Text(labelText ?? "No Annotation Selected")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Image(systemName: "pencil")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .scaledToFit()
                    .foregroundStyle(.white)
            }
            .padding(10)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
        }
    }
    
    var closeButton: some View {
        Button {
            withAnimation {
                closeView()
            }
        } label: {
            Image(systemName: "xmark.square.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(.white)
        }
    }
    
    var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                editLabelView(isEditingTitleLabel: true)
                
                editLabelView(isEditingTitleLabel: false)
                
            }
            
            Spacer()
            
            closeButton
        }
    }
    
    var mainActionButtonView: some View {
        HStack(spacing: 20) {
            ForEach(mainActions, id: \.self) { option in
                VStack {
                    Button {
                        withAnimation {
                            action(for: option)
                        }
                    } label: {
                        Image(systemName: option.buttonImageName)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .scaledToFill()
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Text(option.description)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    var updateColorView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Update Annotation Color")
                .font(.headline)
                .foregroundStyle(.white)
            
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(MainColor.allCases, id: \.self) { color in
                        Button {
                            withAnimation {
                                updateColor(color)
                            }
                        } label: {
                            Circle()
                                .fill(color.color)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: Actions
private extension AnnotationsDetailsView {
    func closeView() {
        selectedAnnotation?.removeHighlight()
        selectedAnnotation = nil
    }
    
    func editAnnotation(isEditingTitleLabel: Bool) {
        if isEditingTitleLabel {
            newTitle = selectedAnnotation?.titleLabel.text ?? ""
            isEditingTitle = true
        } else {
            newTitle = selectedAnnotation?.subtitleLabel.text ?? ""
            isEditingSubTitle = true
        }
    }
    
    func action(for type: DetailsType) {
        switch type {
        case .delete:
            selectedAnnotation?.removeFromParent()
            selectedAnnotation = nil
        case .rotate:
            // Increment the angle by 15 degrees
            let incrementedAngle = angle + 10
            
            // Snap the angle to the nearest 15 degrees (although this may not be necessary since increments are already 15)
            let snappedAngle = round(incrementedAngle / 15) * 15
            
            // Normalize the angle to keep it within 0–360 degrees
            let normalizedAngle = snappedAngle.truncatingRemainder(dividingBy: 360)
            
            // Update the annotation's angle
            selectedAnnotation?.updateAngle(to: normalizedAngle)
            
            // Update the local angle variable
            angle = normalizedAngle
        default: break
        }
    }
    
    func updateColor(_ color: MainColor) {
        selectedAnnotation?.updateColor(color.skColor)
    }
}

#Preview {
    AnnotationsDetailsView(selectedAnnotation: .constant(nil))
}
