//
//  AddFurnitureView.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 26.01.2025.
//

import SwiftUI
import RoomPlan

struct AddFurnitureView: View {
    @ObservedObject var floorPlanViewModel: FloorPlanViewModel
    
    private let allFurniture = CapturedRoom.Object.Category.allCases
    
    @State private var selectedFurniture: CapturedRoom.Object.Category? = nil
    
    var body: some View {
        VStack(spacing: 10) {
            headerView
            
            furnitureList
            
            selectedFurnitureButton
            
            Spacer()
        }
        .padding(.all, 20)
    }
}

// MARK: Views
private extension AddFurnitureView {
    var headerView: some View {
        HStack {
            Text("Select furniture!")
                .font(.title)
            
            Spacer()
            
            Button {
                withAnimation {
                    floorPlanViewModel.furnitureToAdd = nil
                    floorPlanViewModel.shouldAddFurniture = false
                }
            } label: {
                Image(systemName: "xmark.square.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.teal)
            }
        }
    }
    
    var furnitureList: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                ForEach(allFurniture, id: \.self) { object in
                    Button {
                        withAnimation {
                            selectedFurniture = object
                        }
                    } label: {
                        VStack {
                            Image(object.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                            Text(object.displayName)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    var selectedFurnitureButton: some View {
        if let selectedFurniture {
            HStack {
                Button {
                    floorPlanViewModel.furnitureToAdd = selectedFurniture
                } label: {
                    HStack {
                        Image(systemName: "plus.app.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.white)
                        
                        Text(selectedFurniture.displayName)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal, 10)
                    .frame(minWidth: 300)
                    .background(Color.teal)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}

#Preview {
    AddFurnitureView(floorPlanViewModel: FloorPlanViewModel())
}
