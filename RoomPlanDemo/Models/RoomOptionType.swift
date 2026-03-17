//
//  RoomOptionType.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 27.01.2025.
//

import Foundation
import SwiftUI

enum RoomOptionType: String, CaseIterable, Identifiable {
    case furniture
    case anotation
    case exportImage
    
    var id: String { rawValue }
    
    var icon: Image {
        switch self {
        case .furniture:
            Image(systemName: "bed.double.circle")
        case .anotation:
            Image(systemName: "character.textbox")
        case .exportImage:
            Image(systemName: "square.and.arrow.up")
        }
    }
    
    var description: String {
        switch self {
        case .furniture:
            "Furniture"
        case .anotation:
            "Text"
        case .exportImage:
            "Export"
        }
    }
}
