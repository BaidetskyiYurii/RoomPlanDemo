//
//  RoomOptionsView.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 26.01.2025.
//

import SwiftUI

struct RoomOptionsView: View {
    @Binding var selectedOption: RoomOptionType?
    @Binding var shouldAddFurniture: Bool
    @Binding var shouldAddText: Bool
    @Binding var shouldShareImage: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 30) {
                ForEach(RoomOptionType.allCases, id: \.self) { type in
                    Button {
                        withAnimation {
                            switch type {
                                
                            case .furniture:
                                shouldAddFurniture = true
                            case .anotation:
                                shouldAddText = true
                            case .exportImage:
                                shouldShareImage = true
                            }
                            
                            selectedOption = type
                        }
                    } label: {
                        VStack {
                            type.icon
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: 50, height: 50)
                            
                            Text(type.description)
                                .font(.callout)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .padding(.horizontal, 25)
        }
        .frame(height: 100)
        .background(Color.teal)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    RoomOptionsView(selectedOption: .constant(nil),
                    shouldAddFurniture: .constant(false),
                    shouldAddText: .constant(false),
                    shouldShareImage: .constant(false))
}
