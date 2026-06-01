import Foundation
import SpriteKit

class EnemyNode: SKSpriteNode{
    var maxHealth: CGFloat = 1000.0
    var currentHealth: CGFloat = 1000.0
    var movementSpeed: CGFloat = 3.0
    var damage: CGFloat = 10.0
    
    var xpReward: Int = 1
    
    weak var targetPlayer: SKSpriteNode?
    
    var onDeath: ((CGPoint) -> Void)?
    private var baseColor: UIColor
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.baseColor = color
        super.init(texture: texture, color: color, size: size)
        self.name = "enemy"
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysics() {
            self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2.0)
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.allowsRotation = false
            
            self.physicsBody?.categoryBitMask = PhysicsCategories.enemy
            
            self.physicsBody?.collisionBitMask = 0
            
            self.physicsBody?.contactTestBitMask = PhysicsCategories.player
        }
    
    func spawn(at position: CGPoint, target: SKSpriteNode){
        self.position = position
        self.targetPlayer = target
        self.currentHealth = maxHealth
        self.isHidden = false
        self.physicsBody?.isDynamic = true
    }
    
    func update() {
            guard !isHidden, let targetPlayer else { return }
            
            let dx = targetPlayer.position.x - self.position.x
            let dy = targetPlayer.position.y - self.position.y
            
            let angle = atan2(dy, dx)
            self.position.x += cos(angle) * movementSpeed
            self.position.y += sin(angle) * movementSpeed
        }
    
    func takeDamage(_ amount: CGFloat){
        currentHealth -= amount
        
        let flash = SKAction.sequence([
                    SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.05),
                    SKAction.colorize(with: baseColor, colorBlendFactor: 1.0, duration: 0.05)
                ])
        
        self.run(flash, withKey: "damageFlash")
        
        if currentHealth <= 0 {
            die()
        }
    }
    
    private func die(){
        self.isHidden = true
        self.physicsBody?.isDynamic = false
        
        onDeath?(self.position)
    }
}



