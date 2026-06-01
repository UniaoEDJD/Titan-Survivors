import SpriteKit

class TitanBossNode: EnemyNode {
    var healthBar: HealthBarNode!
    
    init(multiplier: CGFloat) {
        super.init(texture: nil, color: .systemYellow, size: CGSize(width: 100, height: 100))
        self.name = "bossTitan"
        
        self.baseMaxHealth = 30000.0 // Extremely tanky
        self.baseDamage = 50.0
        self.movementSpeed = 1.2
        self.xpReward = 1000 // Huge level up on kill
        
        self.maxHealth = self.baseMaxHealth * multiplier
        self.currentHealth = self.maxHealth
        self.damage = self.baseDamage * multiplier
        
        setupHealthBar()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupHealthBar() {
        healthBar = HealthBarNode()
        healthBar.position = CGPoint(x: 0, y: 70)
        healthBar.setScale(0.5)
        self.addChild(healthBar)
    }
    
    override func takeDamage(_ amount: CGFloat) {
        super.takeDamage(amount)
        healthBar.updateHealth(current: Int(self.currentHealth), maxHealth: Int(self.maxHealth))
        
        if currentHealth <= 0 { self.removeFromParent() } 
    }
}
