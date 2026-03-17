//
//  MainColor.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 27.01.2025.
//

import SwiftUI
import SpriteKit

enum MainColor: CaseIterable {
    case red, orange, yellow, green, blue, indigo, violet, black, white, gray
    
    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .indigo: return .indigo
        case .violet: return .purple
        case .black: return .black
        case .white: return .white
        case .gray: return .gray
        }
    }
    
    var skColor: SKColor {
        switch self {
        case .red: return SKColor.red
        case .orange: return SKColor.orange
        case .yellow: return SKColor.yellow
        case .green: return SKColor.green
        case .blue: return SKColor.blue
        case .indigo: return SKColor.systemIndigo // Using a system color for Indigo
        case .violet: return SKColor.purple
        case .black: return SKColor.black
        case .white: return SKColor.white
        case .gray: return SKColor.gray
        }
    }
}
