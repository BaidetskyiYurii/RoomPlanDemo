//
//  SKShapeNode+Extensions.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 08.01.2025.
//

import SpriteKit

extension SKShapeNode {
    static func create(from path: CGPath,
                       strokeColor: UIColor = DrawParameters.floorPlanSurfaceColor,
                       lineWidth: CGFloat = DrawParameters.surfaceWidth,
                       zPosition: CGFloat? = nil) -> SKShapeNode {
        let shapeNode = SKShapeNode(path: path)
        shapeNode.strokeColor = strokeColor
        shapeNode.lineWidth = lineWidth
        
        if let zPosition {
            shapeNode.zPosition = zPosition
        }
        return shapeNode
    }
}
