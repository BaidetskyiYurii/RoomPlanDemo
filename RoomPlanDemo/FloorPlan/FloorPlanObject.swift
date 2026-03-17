//
//  FloorPlanObject.swift
//  RoomPlanPDP
//
//  Created by Baidetskyi Yurii on 20.01.2025.
//

import SpriteKit
import RoomPlan

final class FloorPlanObject: SKNode {
    
    // MARK: - Properties
    let capturedObject: CapturedRoom.Object
    private let capturedObjectCategory: CapturedRoom.Object.Category
    private var imageNode: SKSpriteNode?
    private var borderNode: SKShapeNode?
    
    // MARK: - Init
    init(capturedObject: CapturedRoom.Object,
         withCategory type: CapturedRoom.Object.Category? = nil,
         objectPosition: CGPoint? = nil) {
        self.capturedObject = capturedObject
        self.capturedObjectCategory = type ?? capturedObject.category
        
        super.init()
        
        // Set the object's position using the transform matrix
        let objectPositionX = -CGFloat(capturedObject.transform.position.x) * DrawParameters.scalingFactor
        let objectPositionY = CGFloat(capturedObject.transform.position.z) * DrawParameters.scalingFactor
        self.position = objectPosition ?? CGPoint(x: objectPositionX, y: objectPositionY)
        
        // Set the object's zRotation using the transform matrix
        self.zRotation = -CGFloat(capturedObject.transform.eulerAngles.z - capturedObject.transform.eulerAngles.y)
        
        loadImage(named: capturedObjectCategory.imageName)
        drawObject()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public  UI Methods
extension FloorPlanObject {
    func updateAngle(to newAngle: CGFloat) {
        // Convert to radians
        let radians = newAngle * (.pi / 180)
        
        // Apply the rotation
        self.zRotation = radians
    }
    
    func select() {
        highlight()
    }
    
    func deselect() {
        borderNode?.removeFromParent()
    }
}

// MARK: Private UI Methods
private extension FloorPlanObject {
    func highlight() {
        let highlightRect = CGRect(
            x: -CGFloat(capturedObject.dimensions.x) * DrawParameters.scalingFactor / 2,
            y: -CGFloat(capturedObject.dimensions.z) * DrawParameters.scalingFactor / 2,
            width: CGFloat(capturedObject.dimensions.x) * DrawParameters.scalingFactor,
            height: CGFloat(capturedObject.dimensions.z) * DrawParameters.scalingFactor
        )
        borderNode = SKShapeNode(rect: highlightRect)
        borderNode?.strokeColor = .red
        borderNode?.lineWidth = 2
        borderNode?.zPosition = DrawParameters.objectOutlineZPosition
        
        if let borderNode = borderNode {
            addChild(borderNode)
        }
    }
    
    func loadImage(named imageName: String) {
        // Load the image from the assets
        let texture = SKTexture(imageNamed: imageName)
        imageNode = SKSpriteNode(texture: texture)
        imageNode?.size = CGSize(
            width: CGFloat(capturedObject.dimensions.x) * DrawParameters.scalingFactor,
            height: CGFloat(capturedObject.dimensions.z) * DrawParameters.scalingFactor
        )
        imageNode?.position = CGPoint(
            x: 0,
            y: 0
        )
        imageNode?.zPosition = DrawParameters.objectZPosition // Set image layer position
        addChild(imageNode!)
        
    }
    
    func drawObject() {
        // Calculate the object's dimensions
        let objectWidth = CGFloat(capturedObject.dimensions.x) * DrawParameters.scalingFactor
        let objectHeight = CGFloat(capturedObject.dimensions.z) * DrawParameters.scalingFactor
        
        // Create the object's rectangle (can be used for the background or shape of the furniture)
        let objectRect = CGRect(
            x: -objectWidth / 2,
            y: -objectHeight / 2,
            width: objectWidth,
            height: objectHeight
        )
        
        // A shape to fill the object (optional for background)
        let objectShape = SKShapeNode(rect: objectRect)
        objectShape.strokeColor = .clear
        objectShape.alpha = 0.3
        objectShape.zPosition = DrawParameters.objectZPosition
        
        // Add both shapes to the node
        addChild(objectShape)
    }
}
