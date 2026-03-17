//
//  CapturedRoom+Extensions.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 24.01.2025.
//

import RoomPlan

extension CapturedRoom.Object.Category {
    var displayName: String {
        switch self {
        case .storage:
            return "Storage"
        case .refrigerator:
            return "Refrigerator"
        case .stove:
            return "Stove"
        case .bed:
            return "Bed"
        case .sink:
            return "Sink"
        case .washerDryer:
            return "Washer/Dryer"
        case .toilet:
            return "Toilet"
        case .bathtub:
            return "Bathtub"
        case .oven:
            return "Oven"
        case .dishwasher:
            return "Dishwasher"
        case .table:
            return "Table"
        case .sofa:
            return "Sofa"
        case .chair:
            return "Chair"
        case .fireplace:
            return "Fireplace"
        case .television:
            return "Television"
        case .stairs:
            return "Stairs"
        @unknown default:
            return "Unknown"
        }
    }
    
    var imageName: String {
        switch self {
        case .storage:
            return "wardrobe"
        case .refrigerator:
            return "machinery"
        case .stove:
            return "stove"
        case .bed:
            return "bed"
        case .sink:
            return "sink"
        case .washerDryer:
            return "dishwasher"
        case .toilet:
            return "toilet"
        case .bathtub:
            return "bath"
        case .oven:
            return "stove"
        case .dishwasher:
            return "dishwasher"
        case .table:
            return "table"
        case .sofa:
            return "sofa"
        case .chair:
            return "armchair"
        case .fireplace:
            return "fireplace"
        case .television:
            return "tv-monitor"
        case .stairs:
            return "steps"
        @unknown default:
            return ""
        }
    }
}
