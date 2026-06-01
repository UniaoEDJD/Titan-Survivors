import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: PlayerNode!
    var cameraNode: SKCameraNode!
    var joystick: VirtualJoystick!
    var objectPool: ObjectPool!
    var spawnManager: SpawnerManager!
    
    let upgradeManager = UpgradeManager()
    let gameManager = GameManager()
    let playerSpeed: CGFloat = 5.0
    var activeWeapons: [Weapon] = []
    
    var requestLevelUpUI: (([UpgradeOption]) -> Void)?
    var healthBar: HealthBarNode!
    var requestGameOverUI: (() -> Void)?
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        setupBackground()
        setupPlayer()
        setupCamera()
        setupJoystick()
        
        objectPool = ObjectPool(scene: self, player: player)
        spawnManager = SpawnerManager(objectPool: objectPool, scene: self)
        
        gameManager.onLevelUp = { [weak self] in
                    guard let self = self else { return }
                    
                    self.isPaused = true
                    
                    let draftedCards = self.upgradeManager.rollUpgrades(count: 3)
                    
                    self.requestLevelUpUI?(draftedCards)
                }
        gameManager.onGameOver = { [weak self] in
            guard let self else { return }
            
            self.isPaused = true
            
            self.requestGameOverUI?()
        }
        
        activeWeapons.append(DualBlades(upgradeManager: upgradeManager))
        
        scatterPowerUp(weaponID: "thunderspear", amount: 5, around: .zero, maxRadius: 1500)
    }
    
    func resumeGame(afterPicking upgrade: UpgradeOption) {
        upgradeManager.applyUpgrade(upgrade)
        self.scene?.isPaused = false
        gameManager.resumeLevelUp()
        }
    
    func setupBackground() {
        let background = SKSpriteNode(color: SKColor.darkGray, size: CGSize(width: 3000, height: 3000))
        background.zPosition = -1
        addChild(background)
    }
    
    func setupPlayer() {
        player = PlayerNode(upgradeManager: upgradeManager, gameManager: gameManager)
        player.position = .zero
        addChild(player)
        
        player.onHealthChange = { [weak self] currentHP, maxHP in
            self?.healthBar.updateHealth(current: currentHP, maxHealth: maxHP)
        }
    }
        
    func setupCamera() {
        cameraNode = SKCameraNode()
        self.camera = cameraNode
        addChild(cameraNode)
        
        healthBar = HealthBarNode()
        healthBar.zPosition = 100
        let xPos = -(size.width / 2) + 40
        let yPos = (size.height / 2) - 40
        healthBar.position = CGPoint(x: xPos, y: yPos)
        cameraNode.addChild(healthBar)
    }
        
    func setupJoystick() {
            joystick = VirtualJoystick()
            
            let xPos = -(size.width/2) + 100
            let yPos = -(size.height/2) + 100
            joystick.position = CGPoint(x: xPos, y: yPos)
            
            cameraNode.addChild(joystick)
    }
    
    var lastTime : TimeInterval = 0
    
    override func update(_ currentTime: TimeInterval) {
        if lastTime == 0 { lastTime = currentTime }
        let delta_time = currentTime - lastTime
        lastTime = currentTime
        player.timeLastDash += delta_time
        
        gameManager.update(dt: delta_time)
        if gameManager.currentState == .playing {
            spawnManager.update(dt: delta_time, runTime: gameManager.runTime, playerPos: player.position)
            
            for weapon in activeWeapons{
                weapon.update(dt: delta_time, player: player, scene: self, globalDamageMult: upgradeManager.GlobalDamageMult)
            }
        }
        if joystick.velocity != .zero && !player.isDashing {
            player.move(with: joystick.velocity)
        }
        
        cameraNode.position = player.position
        for enemy in objectPool.allEnemies {
            enemy.update()
        }
        
        for node in self.children where node.name?.hasPrefix("pickup_") == true {
            let dx = player.position.x - node.position.x
            let dy = player.position.y - node.position.y
            let distance = sqrt((dx * dx) + (dy * dy))
            
            if distance > 2500 {
                let newAngle = CGFloat.random(in: 0...(2 * .pi))
                let newDistance: CGFloat = 1200.0
                
                node.position = CGPoint(x: player.position.x + (cos(newAngle) * newDistance), y: player.position.y + (sin(newAngle) * newDistance))
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        let bitMaskA = contact.bodyA.categoryBitMask
        let bitMaskB = contact.bodyB.categoryBitMask
        let collision = bitMaskA | bitMaskB
        
        if collision == PhysicsCategories.player | PhysicsCategories.expGem {
            let gemNode = (bitMaskA == PhysicsCategories.expGem) ? contact.bodyA.node : contact.bodyB.node
            
            if let gem = gemNode as? ExperienceNode{
                let scaledXP = Int(Double(gem.xpValue) * upgradeManager.xpMultiplier)
                gameManager.gainXp(xpAmount: scaledXP)
                
                gem.run(SKAction.sequence([
                    SKAction.scale(to: 0, duration: 0.1)
                    ,SKAction.removeFromParent()
                ]))
            }
        }
        if collision == PhysicsCategories.player | PhysicsCategories.enemy {
            let enemyNode = (bitMaskA == PhysicsCategories.enemy) ? contact.bodyA.node : contact.bodyB.node
            
            if let enemy = enemyNode as? EnemyNode{
                player.takeDamage(Int(enemy.damage))
            }
        }
        if collision == PhysicsCategories.player | PhysicsCategories.powerUp {
            let pickupNode = (bitMaskA == PhysicsCategories.powerUp) ? contact.bodyA.node : contact.bodyB.node
            
            if let pickup = pickupNode as? WeaponPickupNode {
                let acquiredID = pickup.weaponID
                if acquiredID == "thunderspear"{
                    activeWeapons.append(ThunderSpears(upgradeManager: upgradeManager))
                }
                
                self.enumerateChildNodes(withName: "pickup_\(acquiredID)") { matchingNode, _ in
                    matchingNode.physicsBody = nil
                    
                    matchingNode.run(SKAction.sequence([SKAction.scale(to: 0, duration: 0.15), SKAction.removeFromParent()]))
                }
            }
        }
        if collision == PhysicsCategories.player | PhysicsCategories.heal {
                    let healNode = (bitMaskA == PhysicsCategories.heal) ? contact.bodyA.node : contact.bodyB.node
                    
                    if let heal = healNode as? HealthPickupNode {
                        player.heal(heal.healAmount)
                        
                        heal.run(SKAction.sequence([
                            SKAction.scale(to: 0, duration: 0.1),
                            SKAction.removeFromParent()
                        ]))
                    }
                }
    }
        
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        if let joystick = joystick
        {
            let xPos = -(size.width / 2) + 120
            let yPos = -(size.height / 2) + 100
            joystick.position = CGPoint(x: xPos, y: yPos)
        }
        if let healthBar = healthBar
        {
            let xPos = -(size.width / 2) + 40
            let yPos = (size.height / 2) - 40
            healthBar.position = CGPoint(x: xPos, y: yPos)
        }
    }
    
    func killAllActiveEnemies() {
        for enemy in objectPool.allEnemies where !enemy.isHidden {
            enemy.takeDamage(10000)
        }
    }
    
    func scatterPowerUp(weaponID: String, amount: Int, around center: CGPoint, maxRadius: CGFloat)
    {
        let angleStep = (2 * .pi) / CGFloat(amount)
        
        for i in 0..<amount {
            let baseAngle = angleStep * CGFloat(i)
            let randomVariance = CGFloat.random(in: -0.2...0.2)
            let finalAngle = baseAngle + randomVariance
            
            let distance = CGFloat.random(in: 1200...1800)
            
            let spawnPos = CGPoint(x: center.x + (cos(finalAngle) * distance), y: center.y + (sin(finalAngle) * distance))
            
            let pickup = WeaponPickupNode(position: spawnPos, weaponID: weaponID)
            addChild(pickup)
        }
    }
}
