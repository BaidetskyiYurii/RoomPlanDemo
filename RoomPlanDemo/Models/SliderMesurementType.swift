//
//  SliderMesurementType.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 19.01.2025.
//

import Foundation

enum SliderMesurementType: Equatable, Hashable {
    case angle(CGFloat)
    case width(CGFloat)
    case depth(CGFloat)
    case xPosition(Double)
    case yPosition(Double)
    case zPosition(Double)
    
    var convertedText: String {
        switch self {
        case .angle(let updatedValue):
            "\(Int(updatedValue.radiansToDegrees))°"
        case .width(let updatedValue), .depth(let updatedValue):
            String(format: "%.1f meters", updatedValue / 100)
        case .xPosition(let updatedValue), .yPosition(let updatedValue), .zPosition(let updatedValue):
            "\(updatedValue)"
        }
    }
    
    var title: String {
        switch self {
        case .angle:
            "Adjust Angle:"
        case .width:
            "Adjust Width:"
        case .depth:
            "Adjust Depth:"
        case .xPosition:
            "Adjust X Position:"
        case .yPosition:
            "Adjust Y Position:"
        case .zPosition:
            "Adjust Z Position:"
        }
    }
    
    var minimumValueLabel: String {
        switch self {
        case .angle:
            "-180°"
        case .width:
            "10 cm"
        case .depth:
            "0 m"
        case .xPosition, .yPosition, .zPosition:
            ""
        }
    }
    
    var maximumValueLabel: String {
        switch self {
        case .angle:
            "180°"
        case .width:
            "10 m"
        case .depth:
            "1 m"
        case .xPosition, .yPosition, .zPosition:
            ""
        }
    }
    
    var closedRange: ClosedRange<CGFloat> {
        switch self {
        case .angle:
            -(.pi)...(.pi)
        case .width:
            10...1000
        case .depth:
            1...100
        case .xPosition, .yPosition, .zPosition:
            0...0
        }
    }
}
