//
//  DrawParameters.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 08.01.2025.
//

import UIKit

struct DrawParameters {
    // Universal scaling factor
    static let scalingFactor: CGFloat = 200
    
    // Sizes
    static let floorPlanSize: CGSize = .init(width: 1500, height: 1500)
    static let floorPlanAnchorPoint: CGPoint = .init(x: 0.5, y: 0.5)
    
    // Line widths
    static let wallWidth: CGFloat = 30.0
    static let surfaceWidth: CGFloat = 22.0
    static let hideSurfaceWidth: CGFloat = 24.0
    static let windowWidth: CGFloat = 8.0
    static let doorArcWidth: CGFloat = 8.0
    static let objectOutlineWidth: CGFloat = 8.0

    // zPositions
    static let hideSurfaceZPosition: CGFloat = 1

    static let windowZPosition: CGFloat = 10
    static let windowArcZPosition: CGFloat = 21

    static let doorZPosition: CGFloat = 20
    static let doorArcZPosition: CGFloat = 21

    static let objectZPosition: CGFloat = 30
    static let objectOutlineZPosition: CGFloat = 31
    
    static let annotationZPosition: CGFloat = 40
    
    // Colors
    static let floorPlanBackgroundColor: UIColor = .white
    static let floorPlanSurfaceColor: UIColor = .cyan
}
