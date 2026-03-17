//
//  FloorPlanSurface.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 08.01.2025.
//

import SpriteKit
import RoomPlan

final class FloorPlanSurface: SKNode, Identifiable {
    // MARK: - Properties
    let capturedSurface: CapturedRoom.Surface
    var selectedShape: SKShapeNode?
    var openDirection: OpenDirection = .clockwise
    
    private var borderNode: SKShapeNode?
    private var hideWallShape: SKShapeNode?
    private var arcShape: SKShapeNode?
    
    // MARK: - Computed properties
    var halfLength: CGFloat {
        didSet {
            drawSurface() // Re-render when height changes
        }
    }
    
    private var pointA: CGPoint {
        return CGPoint(x: -halfLength, y: 0)
    }
    
    private var pointB: CGPoint {
        return CGPoint(x: halfLength, y: 0)
    }
    
    private var pointC: CGPoint {
        return pointB.rotateAround(point: pointA, by: openDirection.angle)
    }
    
    // MARK: - Init
    init(capturedSurface: CapturedRoom.Surface) {
        self.capturedSurface = capturedSurface
        self.halfLength = CGFloat(capturedSurface.dimensions.x) * DrawParameters.scalingFactor / 2
        
        super.init()
        
        // Set the surface's position using the transform matrix
        let surfacePositionX = -CGFloat(capturedSurface.transform.position.x) * DrawParameters.scalingFactor
        let surfacePositionY = CGFloat(capturedSurface.transform.position.z) * DrawParameters.scalingFactor
        self.position = CGPoint(x: surfacePositionX,
                                y: surfacePositionY)
        
        // Set the surface's zRotation using the transform matrix
        self.zRotation = -CGFloat(capturedSurface.transform.eulerAngles.z - capturedSurface.transform.eulerAngles.y)
        
        // Draw the right surface
        drawSurface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: Public Methods
extension FloorPlanSurface {
    func select() {
        updateHighlight()
    }
    
    func deselect() {
        borderNode?.removeFromParent()
    }
    
    func updateDoorOpenDirection(to newValue: OpenDirection) {
        self.openDirection = newValue
        drawSurface()
    }
    
    func updateAngleRadians(to newAngle: CGFloat) {
        // Convert to radians
        let radians = newAngle * (.pi / 180)
        
        // Apply the rotation
        self.zRotation = radians
    }
    
    func updateAngle(to newAngle: CGFloat) {
        // Apply the rotation
        self.zRotation = newAngle
    }
    
    func updateWidth(to newValue: CGFloat) {
        halfLength = newValue
        updateHighlight()
    }
    
    func updateDepth(to newValue: CGFloat) {
        selectedShape?.lineWidth = newValue
        hideWallShape?.lineWidth = newValue
    }
    
    func updatePosition(x: Double? = nil,
                        y: Double? = nil,
                        z: Double? = nil) {
        let currentPosition = self.position
        let currentZPosition = self.zPosition
        
        self.position = CGPoint(x: x ?? currentPosition.x,
                                y: y ?? currentPosition.y)
        self.zPosition = z ?? currentZPosition
    }
}


// MARK: Private methods
private extension FloorPlanSurface {
    func drawSurface() {
        switch capturedSurface.category {
        case .door:
            drawDoor()
        case .wall:
            drawWall()
        case .window:
            drawWindow()
        case .floor, .opening:
            break
        @unknown default:
            break
        }
    }
    
    func drawWall(with wallWidth: CGFloat = DrawParameters.wallWidth ) {
        let wallPath = CGMutablePath.create(from: pointA, to: pointB)
        // Check if the wall already exists
        if let existingWall = selectedShape {
            // Modify the existing wall's path and properties
            existingWall.path = wallPath
        } else {
            // If the wall doesn't exist, create a new one
            let newWallShape = SKShapeNode.create(
                from: wallPath,
                strokeColor: .black,
                lineWidth: wallWidth)
            newWallShape.lineCap = .square
            
            // Store the reference to the wall shape
            selectedShape = newWallShape
            
            // Add the wall to the scene
            addChild(newWallShape)
        }
    }
    
    func drawDoor() {
        // Hide the wall underneath the door
        let doorPath = CGMutablePath.create(from: pointA, to: pointC)
        let hideWallPath = CGMutablePath.create(from: pointA, to: pointB)
        let doorArcPath = createArcPath()
        
        if let doorShape = selectedShape {
            doorShape.path = doorPath
        } else {
            // The door itself
            let doorShape = SKShapeNode.create(
                from: doorPath,
                zPosition: DrawParameters.doorZPosition)
            doorShape.lineCap = .square
            
            // Store the reference to the wall shape
            selectedShape = doorShape
            
            // Add the wall to the scene
            addChild(doorShape)
        }
        
        if let hideWallShape = hideWallShape {
            hideWallShape.path = hideWallPath
        } else {
            let hideWallShape = SKShapeNode.create(
                from: hideWallPath,
                strokeColor: DrawParameters.floorPlanSurfaceColor,
                lineWidth: DrawParameters.hideSurfaceWidth,
                zPosition:  DrawParameters.hideSurfaceZPosition)
            
            // Store the reference to the wall shape
            self.hideWallShape = hideWallShape
            
            // Add the wall to the scene
            addChild(hideWallShape)
        }
        
        if let doorArcShape = arcShape {
            doorArcShape.path = doorArcPath
        } else {
            let doorArcShape = SKShapeNode.create(
                from: doorArcPath,
                lineWidth: DrawParameters.doorArcWidth,
                zPosition: DrawParameters.doorArcZPosition)
            
            // Store the reference to the wall shape
            self.arcShape = doorArcShape
            
            // Add the wall to the scene
            addChild(doorArcShape)
        }
    }
    
    func drawWindow() {
        let windowPath = CGMutablePath.create(from: pointA, to: pointC)
        let hideWallPath = CGMutablePath.create(from: pointA, to: pointB)
        let windowArcPath = createArcPath()
        
        if let windowShape = selectedShape {
            windowShape.path = windowPath
        } else {
            // The door itself
            let windowShape = SKShapeNode.create(
                from: windowPath,
                zPosition: DrawParameters.windowZPosition)
            windowShape.lineCap = .square
            
            // Store the reference to the wall shape
            selectedShape = windowShape
            
            // Add the wall to the scene
            addChild(windowShape)
        }
        
        if let hideWallShape = hideWallShape {
            hideWallShape.path = hideWallPath
        } else {
            let hideWallShape = SKShapeNode.create(
                from: hideWallPath,
                strokeColor: DrawParameters.floorPlanSurfaceColor,
                lineWidth: DrawParameters.hideSurfaceWidth,
                zPosition:  DrawParameters.hideSurfaceZPosition)
            
            // Store the reference to the wall shape
            self.hideWallShape = hideWallShape
            
            // Add the wall to the scene
            addChild(hideWallShape)
        }
        
        if let windowArcShape = arcShape {
            windowArcShape.path = windowArcPath
        } else {
            let windowArcShape = SKShapeNode.create(
                from: windowArcPath,
                lineWidth: DrawParameters.doorArcWidth,
                zPosition: DrawParameters.windowZPosition)
            
            // Store the reference to the wall shape
            self.arcShape = windowArcShape
            
            // Add the wall to the scene
            addChild(windowArcShape)
        }
    }
    
    func createArcPath() -> CGPath {
        let doorArcPath = CGMutablePath()
        // The door's arc
        doorArcPath.addArc(
            center: pointA,
            radius: halfLength * 2,
            startAngle: openDirection.arcStartAngle,
            endAngle: openDirection.arcEndAngle,
            clockwise: true
        )
        
        // Create a dashed path
        let dashPattern: [CGFloat] = [24.0, 8.0]
        let dashedArcPath = doorArcPath.copy(dashingWithPhase: 1, lengths: dashPattern)
        return dashedArcPath
    }
    
    func updateHighlight() {
        let highlightRect = calculateBoundingRect()
        
        borderNode?.removeFromParent()
        borderNode = SKShapeNode(rect: highlightRect)
        borderNode?.strokeColor = .blue.withAlphaComponent(0.2)
        borderNode?.lineWidth = DrawParameters.surfaceWidth + 2
        borderNode?.zPosition = DrawParameters.surfaceWidth + 1
        borderNode?.glowWidth = DrawParameters.surfaceWidth + 2
        
        if let borderNode = borderNode {
            addChild(borderNode)
        }
    }
    
    func calculateBoundingRect() -> CGRect {
        let width = halfLength * 2
        let height: CGFloat = 5.0 // Fixed height for surfaces like walls, windows, etc.
        return CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
    }
}
