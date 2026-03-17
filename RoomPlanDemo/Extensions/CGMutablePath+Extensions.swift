//
//  CGMutablePath+Extensions.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 08.01.2025.
//

import CoreGraphics

extension CGMutablePath {
    static func create(from pointA: CGPoint, to pointB: CGPoint) -> CGMutablePath {
        let path = CGMutablePath()
        path.move(to: pointA)
        path.addLine(to: pointB)
        return path
    }
}
