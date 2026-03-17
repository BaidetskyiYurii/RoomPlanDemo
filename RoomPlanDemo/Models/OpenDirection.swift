//
//  OpenDirection.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 27.01.2025.
//

import Foundation

enum OpenDirection: CaseIterable {
    case clockwise
    case counterClockwise
    
    var angle: CGFloat {
        switch self {
        case .clockwise:
            -0.25 * .pi
        case .counterClockwise:
            0.25 * .pi
        }
    }
    
    var arcStartAngle: CGFloat {
        switch self {
        case .clockwise:
            0
        case .counterClockwise:
            0.25 * .pi
        }
    }
    
    var arcEndAngle: CGFloat {
        switch self {
        case .clockwise:
            -0.25 * .pi
        case .counterClockwise:
            0
        }
    }
    
    var description: String {
        switch self {
        case .clockwise:
            "Clockwise"
        case .counterClockwise:
            "Counter Clockwise"
        }
    }
}
