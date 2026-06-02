import SpriteKit

class WeaponPickupNode : SKSpriteNode
{
    let weaponID : String
    
    init(position: CGPoint, weaponID: String)
    {
        self.weaponID = weaponID
        
        let texture: SKTexture? = (weaponID == "thunderspear") ? SKTexture(imageNamed: "thunderspear") : nil
        let color: UIColor = (texture == nil) ? .orange : .clear
        
        super.init(texture: texture, color: color, size: CGSize(width: 30, height: 30))
        
        if let tex = texture {
            tex.filteringMode = .nearest
        }
        
        self.position = position
        
        self.name = "pickup_\(weaponID)"
        
        setupPhysics()
        
        let pulseUp = SKAction.scale(to: 1.2, duration: 0.5)
        let pulseDown = SKAction.scale(to: 1.0, duration: 0.5)
        self.run(SKAction.repeatForever(SKAction.sequence([pulseUp,pulseDown])))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("Init(coder: has not been implemented")
    }
    
    private func setupPhysics()
    {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategories.powerUp
        self.physicsBody?.contactTestBitMask = PhysicsCategories.player
        self.physicsBody?.collisionBitMask = PhysicsCategories.none
    }
}
