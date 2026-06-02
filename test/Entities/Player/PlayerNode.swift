import SpriteKit

class PlayerNode : SKSpriteNode {
    var upgradeManager: UpgradeManager
    
    private var isInvincible: Bool = false
    
    weak var gameManager: GameManager?
    
    var onHealthChange: ((Int, Int) -> Void)?
    
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
    
    var isDashing: Bool = false
    var timeLastDash: TimeInterval = 3.0
    var dashCooldown: TimeInterval = 3.0
    
    // Animation properties
    enum Direction { case up, down, left, right, idle }
    var currentDirection: Direction = .idle
    var lastFacing: Direction = .down
    var walkAnimations: [Direction: SKAction] = [:]
    var idleTextures: [Direction: SKTexture] = [:]
    
    init(upgradeManager: UpgradeManager, gameManager: GameManager) {
        self.upgradeManager = upgradeManager
        self.gameManager = gameManager
        
        self.currentHealth = upgradeManager.effectiveMaxHealth
        
        super.init(texture: nil, color: .clear, size: CGSize(width: 40, height: 40))
        self.name = "player"
        
        setupAnimations()
        self.texture = idleTextures[.down]
        
        setupPhysics()
    }
    
    private func setupAnimations() {
        let sheet = SKTexture(imageNamed: "player_sheet")
        sheet.filteringMode = .nearest
        
        let cols: CGFloat = 3
        let rows: CGFloat = 4
        let frameW = 1.0 / cols
        let frameH = 1.0 / rows
        
        func extractRow(row: Int) -> [SKTexture] {
            var frames = [SKTexture]()
            for col in 0..<Int(cols) {
                let x = CGFloat(col) * frameW
                let y = CGFloat(row) * frameH
                let rect = CGRect(x: x, y: y, width: frameW, height: frameH)
                let tex = SKTexture(rect: rect, in: sheet)
                tex.filteringMode = .nearest
                frames.append(tex)
            }
            return frames
        }
        
        let upFrames = extractRow(row: 0)
        let rightFrames = extractRow(row: 1)
        let leftFrames = extractRow(row: 2)
        let downFrames = extractRow(row: 3)
        
        func createWalkAction(frames: [SKTexture]) -> SKAction {
            let loopFrames = [frames[1], frames[0], frames[1], frames[2]]
            return SKAction.repeatForever(SKAction.animate(with: loopFrames, timePerFrame: 0.15))
        }
        
        walkAnimations[.up] = createWalkAction(frames: upFrames)
        walkAnimations[.right] = createWalkAction(frames: rightFrames)
        walkAnimations[.left] = createWalkAction(frames: leftFrames)
        walkAnimations[.down] = createWalkAction(frames: downFrames)
        
        idleTextures[.up] = upFrames[1]
        idleTextures[.right] = rightFrames[1]
        idleTextures[.left] = leftFrames[1]
        idleTextures[.down] = downFrames[1]
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
        
        self.physicsBody?.collisionBitMask = PhysicsCategories.solidObstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategories.enemy
    }
    
    func stopMoving() {
        if currentDirection != .idle {
            currentDirection = .idle
            self.removeAction(forKey: "walk")
            self.texture = idleTextures[lastFacing] ?? self.texture
        }
    }
    
    func move(with velocity: CGPoint){
        self.position.x += velocity.x * currentSpeed
        self.position.y += velocity.y * currentSpeed
        
        let newDir: Direction
        if abs(velocity.x) > abs(velocity.y) {
            newDir = velocity.x > 0 ? .right : .left
        } else {
            newDir = velocity.y > 0 ? .up : .down
        }
        
        if newDir != currentDirection {
            currentDirection = newDir
            lastFacing = newDir
            self.removeAction(forKey: "walk")
            if let walkAction = walkAnimations[newDir] {
                self.run(walkAction, withKey: "walk")
            }
        }
    }
    
    func takeDamage(_ amount: Int){
        guard !isInvincible, currentHealth > 0 else { return }
        isInvincible = true
        currentHealth -= amount
        onHealthChange?(currentHealth, maxHealth)
        
        let flash = SKAction.sequence([
            SKAction.colorize(with: .red, colorBlendFactor: 0.8, duration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0, duration: 0.1)
        ])
        
        let resetFrames = SKAction.sequence([
                    SKAction.wait(forDuration: 0.5),
                    SKAction.run { [weak self] in self?.isInvincible = false }
                ])
        
        self.run(SKAction.group([flash, resetFrames]))
        if currentHealth <= 0 {
            die()
        }
    }
    
    private func die(){
        self.physicsBody?.isDynamic = false
        self.isHidden = true
        gameManager?.triggerGameOver()
    }
    
    func performDash(joystickVel: CGPoint)
    {
        guard !isDashing, timeLastDash >= dashCooldown else { return }
        
        let dashDir = joystickVel == .zero ? CGPoint(x: 1, y: 0) : joystickVel
        
        isDashing = true
        timeLastDash = 0.0
        
        self.physicsBody?.contactTestBitMask = PhysicsCategories.none
        
        let dashDistance = 200.0
        let moveX = dashDir.x * dashDistance
        let moveY = dashDir.y * dashDistance
        
        let dashAction = SKAction.moveBy(x: moveX, y: moveY, duration: 0.25)
        dashAction.timingMode = .easeOut
        
        let stretch = SKAction.scaleX(to: 1.5, y: 0.5, duration: 0.1)
        let unstretch = SKAction.scaleX(to: 1.0, y: 1.0, duration: 0.15)
        let visualEffect = SKAction.sequence([stretch, unstretch])
        
        let finishDash = SKAction.run { [weak self] in
            self?.isDashing = false
            self?.physicsBody?.contactTestBitMask = PhysicsCategories.enemy
        }
        self.run(SKAction.group([dashAction, visualEffect]))
        self.run(SKAction.sequence([SKAction.wait(forDuration: 0.25), finishDash]))
    }
    
    func heal(_ amount: Int) {
        currentHealth += amount
        onHealthChange?(currentHealth, maxHealth)
            
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
        print("❤️ Vida recuperada! HP Atual: \(currentHealth)/\(maxHealth)")
        let flashGreen = SKAction.sequence([
            SKAction.colorize(with: .green, colorBlendFactor: 0.6, duration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)
        ])
        self.run(flashGreen)
    }
}
