//
//  ImageFormat.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 27.01.2025.
//

import Foundation

enum ImageFormat: String, CaseIterable {
    case png
    case jpeg
    case pdf
    
    var descriptionFormat: String {
        switch self {
        case .png:
            "PNG"
        case .jpeg:
            "JPEG"
        case .pdf:
            "PDF"
        }
    }
}
