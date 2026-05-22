import SpriteKit

class ExperienceNode: SKSpriteNode {
    let xpValue: Int
    
    init(value: Int = 1) {
        self.xpValue = value
        
        super.init(texture: nil, color: .yellow, size: CGSize(width: 12, height: 12))
        self.name = "experience"
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 6)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategories.expGem
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PhysicsCategories.player
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
