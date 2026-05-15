import Foundation
import SpriteKit

class NormalTitan: EnemyNode {
    init() {
        super.init(texture: nil, color: .systemGreen, size: CGSize(width: 30, height: 30))
        
        self.maxHealth = 1000.0
        self.movementSpeed = 2.0
        self.damage = 1.0
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
