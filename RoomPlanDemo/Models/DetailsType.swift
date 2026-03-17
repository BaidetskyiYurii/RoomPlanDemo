//
//  DetailsType.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 19.01.2025.
//

import Foundation

enum DetailsType: String, CaseIterable, Identifiable {
    case measurements
    case doorDirection
    case delete
    case rotate
    
    var buttonImageName: String {
        switch self {
        case .measurements:
            "square.resize"
        case .doorDirection:
            "door.left.hand.open"
        case .delete:
            "trash"
        case .rotate:
            "rotate.left"
        }
    }
    
    var description: String {
        switch self {
        case .measurements:
            "Resize"
        case .doorDirection:
            "Open Direction"
        case .delete:
            "Delete"
        case .rotate:
            "Rotate"
        }
    }
    
    var id: String { rawValue }
}
