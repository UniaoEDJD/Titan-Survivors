import SpriteKit

class HealthPickupNode: SKSpriteNode {
    let healAmount: Int
    
    init(healAmount: Int = 10) {
        self.healAmount = healAmount
        
        // Visual: Um quadrado rosa/rosa-choque
        super.init(texture: nil, color: .systemPink, size: CGSize(width: 14, height: 14))
        self.name = "healPickup"
        
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: 7)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false
        
        // Configuração das máscaras
        self.physicsBody?.categoryBitMask = PhysicsCategories.heal
        self.physicsBody?.collisionBitMask = 0 // Fantasma: todos passam por cima
        self.physicsBody?.contactTestBitMask = PhysicsCategories.player // Só avisa se o player tocar
    }
}
