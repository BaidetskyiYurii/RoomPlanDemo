import SpriteKit

final class FloorPlanAnnotation: SKNode, Identifiable {
    // MARK: - Properties
    let titleLabel: SKLabelNode
    let subtitleLabel: SKLabelNode
    private var borderNode: SKShapeNode?
    
    // MARK: - Initializer
    init(title: String,
         subtitle: String,
         fontSize: CGFloat = 40,
         fontColor: UIColor = .red) {
        // Initialize labels
        titleLabel = SKLabelNode(text: title)
        subtitleLabel = SKLabelNode(text: subtitle)
        
        super.init()
        
        setupLabels(title: title,
                    subtitle: subtitle,
                    fontSize: fontSize,
                    fontColor: fontColor)
        
        self.zPosition = DrawParameters.annotationZPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public UI Methods
extension FloorPlanAnnotation {
    func updateTitle(_ newTitle: String) {
        titleLabel.text = newTitle
        createOrUpdateBorder()
    }
    
    func updateSubTitle(_ newSubtitle: String) {
        subtitleLabel.text = newSubtitle
        createOrUpdateBorder()
    }
    
    func highlight() {
        createOrUpdateBorder()
    }
    
    
    func removeHighlight() {
        // Remove the border node if it exists
        borderNode?.removeFromParent()
        borderNode = nil
    }
    
    func updateAngle(to newAngle: CGFloat) {
        // Convert to radians
        let radians = newAngle * (.pi / 180)
        
        // Apply the rotation
        self.zRotation = radians
    }
    
    func updateColor(_ newColor: SKColor) {
        titleLabel.fontColor = newColor
        subtitleLabel.fontColor = newColor
    }
}

// MARK: Private UI Methods
extension FloorPlanAnnotation {
    func setupLabels(title: String,
                     subtitle: String,
                     fontSize: CGFloat = 40,
                     fontColor: UIColor = .red) {
        // Configure title label
        titleLabel.fontName = "Helvetica-Bold"
        titleLabel.fontSize = fontSize
        titleLabel.fontColor = fontColor
        titleLabel.position = CGPoint(x: 0, y: fontSize / 2) // Adjust position for
        
        // Configure subtitle label
        subtitleLabel.fontName = "Helvetica"
        subtitleLabel.fontSize = fontSize * 0.8 // Slightly smaller font for subtitle
        subtitleLabel.fontColor = fontColor.withAlphaComponent(0.8)
        subtitleLabel.position = CGPoint(x: 0, y: -fontSize / 2) // Below the title
        
        // Add labels as children
        addChild(titleLabel)
        addChild(subtitleLabel)
    }
    
    func createOrUpdateBorder() {
        // Remove existing border if present
        borderNode?.removeFromParent()
        
        // Calculate bounding box for both labels
        let titleBoundingBox = titleLabel.frame
        let subtitleBoundingBox = subtitleLabel.frame
        
        let combinedBoundingBox = titleBoundingBox.union(subtitleBoundingBox)
        let padding: CGFloat = 10
        
        let borderSize = CGRect(
            x: combinedBoundingBox.origin.x - padding,
            y: combinedBoundingBox.origin.y - padding,
            width: combinedBoundingBox.size.width + 2 * padding,
            height: combinedBoundingBox.size.height + 2 * padding
        )
        
        let border = SKShapeNode(rect: borderSize, cornerRadius: 10)
        border.strokeColor = .black
        border.lineWidth = 2
        border.zPosition = zPosition - 1 // Place behind the labels
        
        addChild(border)
        borderNode = border
    }
}
