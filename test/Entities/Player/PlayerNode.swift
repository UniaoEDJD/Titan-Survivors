import SpriteKit

class PlayerNode : SKSpriteNode {
    var upgradeManager: UpgradeManager
    
    weak var gameManager: GameManager?
    
    private let baseSpeed: CGFloat = 5.0
    var currentHealth: Int
    
    var currentSpeed: CGFloat{
        return baseSpeed + CGFloat(upgradeManager.playerSpeedMult)
    }
    
    var maxHealth: Int {
        return upgradeManager.effectiveMaxHealth
    }
    
    var pickupRadius: CGFloat {
        return CGFloat(upgradeManager.MagnetRadius)
    }
    
    init(upgradeManager: UpgradeManager, gameManager: GameManager) {
        self.upgradeManager = upgradeManager
        self.gameManager = gameManager
        
        self.currentHealth = upgradeManager.effectiveMaxHealth
        
        let texture = SKTexture(imageNamed: "player")
        super.init(texture: nil, color: .systemBlue, size: CGSize(width: 40, height: 40))
        self.name = "player"
        
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategories.player
        
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PhysicsCategories.enemy
    }
    
    func move(with velocity: CGPoint){
        self.position.x += velocity.x * currentSpeed
        self.position.y += velocity.y * currentSpeed
    }
    
    func takeDamage(_ amount: Int){
        currentHealth -= amount
        
        let flash = SKAction.sequence([
            SKAction.colorize(with: .red, colorBlendFactor: 0.8, duration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0, duration: 0.1)
        ])
        self.run(flash)
        if currentHealth <= 0 {
            die()
        }
    }
    
    private func die(){
        self.physicsBody?.isDynamic = false
        self.isHidden = true
        gameManager?.triggerGameOver()
    }
}
