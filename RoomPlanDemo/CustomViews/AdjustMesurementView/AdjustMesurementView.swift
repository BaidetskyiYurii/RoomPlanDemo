//
//  AdjustMesurementView.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 19.01.2025.
//

import SwiftUI

struct AdjustMesurementView: View {
    let sliderBinding: Binding<CGFloat>?
    let sliderType: SliderMesurementType
    
    @Binding var newPosition: String
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 25) {
                Text(sliderType.title)
                    .font(.headline)
                
                if sliderBinding != nil {
                    Spacer()
                    
                    Text(sliderType.convertedText)
                } else {
                    HStack(alignment: .center) {
                        TextField(sliderType.title, text: $newPosition)
                    }
                    .padding(10)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            if let sliderBinding {
                Slider(
                    value: sliderBinding,
                    in: sliderType.closedRange,
                    label: {
                        Text(sliderType.title)
                    },
                    minimumValueLabel: {
                        Text(sliderType.minimumValueLabel)
                    },
                    maximumValueLabel: {
                        Text(sliderType.maximumValueLabel)
                    }
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    AdjustMesurementView(
        sliderBinding: .constant(100),
        sliderType: .angle(50),
        newPosition: .constant(""))
}
