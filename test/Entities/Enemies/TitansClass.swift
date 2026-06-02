import Foundation
import SpriteKit

class NormalTitan: EnemyNode {
    init() {
        super.init(texture: nil, color: .systemGreen, size: CGSize(width: 30, height: 30))
        self.name = "normalTitan"
        self.baseMaxHealth = 1000.0
        self.movementSpeed = 2.0
        self.baseDamage = 10.0
        self.xpReward = 1
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AbnormalTitan: EnemyNode {
    init() {
        super.init(texture: nil, color: .systemPurple, size: CGSize(width: 40, height: 40))
        self.name = "abnormalTitan"
        self.baseMaxHealth = 2500.0
        self.movementSpeed = 3.5
        self.baseDamage = 25.0
        self.xpReward = 5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CrawlerTitan: EnemyNode {
    init() {
        super.init(texture: nil, color: .systemRed, size: CGSize(width: 20, height: 20))
        self.name = "crawlerTitan"
        self.baseMaxHealth = 400.0
        self.movementSpeed = 5.5
        self.baseDamage = 5.0
        self.xpReward = 2
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ColossalTitan: EnemyNode {
    var trapCenter: CGPoint = .zero
    
    init() {
        let texture = SKTexture(imageNamed: "colossal_titan")
        texture.filteringMode = .nearest
        super.init(texture: texture, color: .clear, size: CGSize(width: 120, height: 120)) // Massive!
        self.name = "colossalTitan"
        self.baseMaxHealth = 8000.0
        self.movementSpeed = 0.15 // Incredibly slow
        self.baseDamage = 100.0
        self.xpReward = 15
        self.physicsBody?.categoryBitMask = PhysicsCategories.enemy | PhysicsCategories.solidObstacle
        self.physicsBody?.mass = 500.0
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func update(){
        guard !isHidden else { return }
        
        let dx = trapCenter.x - self.position.x
        let dy = trapCenter.y - self.position.y
        let distance = sqrt(dx * dx + dy * dy)
        
        if distance > 0 {
            // Constant, incredibly slow shrinking
            let speedPerSecond = self.movementSpeed * 60.0
            self.physicsBody?.velocity = CGVector(dx: (dx/distance) * speedPerSecond, dy: (dy/distance) * speedPerSecond)
        } else {
            self.physicsBody?.velocity = .zero
        }
    }
    
    override func takeDamage(_ amount: CGFloat) {
        super.takeDamage(amount)
        if currentHealth <= 0 { self.removeFromParent() }
        

    }
}
