//
//  CGFloat+Extensions.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 20.01.2025.
//

import Foundation

extension CGFloat {
    var radiansToDegrees: CGFloat {
        return self * 180 / .pi
    }
    
    var degreesToRadians: CGFloat {
        return self * .pi / 180
    }
}
