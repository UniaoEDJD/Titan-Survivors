import SpriteKit

class DualBlades: Weapon {
    
    var cooldown: TimeInterval = 1.2
    var damage: Double = 670.0
    var attackRange: Double = 150.0
    weak var upgradeManager: UpgradeManager?
    
    private var timeSinceLastAttack: TimeInterval = 0

    init(upgradeManager: UpgradeManager? = nil) {
        self.upgradeManager = upgradeManager
    }
    
    func update(dt: TimeInterval, player: SKNode, scene: SKNode, globalDamageMult: Double) {
        timeSinceLastAttack += dt

        let state = upgradeManager?.weaponStates["dualblades"] ?? WeaponUpgradeState()
        let effectiveCooldown = cooldown * state.cooldownMult
        
        if timeSinceLastAttack >= effectiveCooldown {
            if let gameScene = scene as? SKScene {
                let targets = getQuadrantedTargets(player: player, in: gameScene, count: 1 + state.extraShots)
                if !targets.isEmpty {
                    for target in targets {
                        fireSlash(from: player, towards: target, scene: gameScene, multiplier: globalDamageMult)
                    }
                    timeSinceLastAttack = 0
                }
            }
        }
    }
    
    func getQuadrantedTargets(player: SKNode, in scene: SKScene, count: Int) -> [EnemyNode] {
        let activeEnemies = scene.children.compactMap { $0 as? EnemyNode }.filter { !$0.isHidden }
        let sorted = activeEnemies.sorted {
            let dx1 = $0.position.x - player.position.x
            let dy1 = $0.position.y - player.position.y
            let dx2 = $1.position.x - player.position.x
            let dy2 = $1.position.y - player.position.y
            return (dx1*dx1 + dy1*dy1) < (dx2*dx2 + dy2*dy2)
        }
        
        var targets = [EnemyNode]()
        var quadrants = Set<Int>()
        
        for enemy in sorted {
            let dx = enemy.position.x - player.position.x
            let dy = enemy.position.y - player.position.y
            let distSq = dx*dx + dy*dy
            if distSq > attackRange * attackRange { continue }
            
            let q: Int
            if dx >= 0 && dy >= 0 { q = 1 }
            else if dx < 0 && dy >= 0 { q = 2 }
            else if dx < 0 && dy < 0 { q = 3 }
            else { q = 4 }
            
            if !quadrants.contains(q) {
                quadrants.insert(q)
                targets.append(enemy)
                if targets.count >= count { break }
            }
        }
        return targets
    }
    
    private func fireSlash(from player: SKNode, towards target: SKNode, scene: SKScene, multiplier: Double) {
        
        let radius: CGFloat = 40.0
        let finalDamage = self.damage * multiplier
        
        let allEnemies = scene.children.compactMap { $0 as? EnemyNode }.filter { !$0.isHidden }
        
        for enemyNode in allEnemies {
            let dx = enemyNode.position.x - target.position.x
            let dy = enemyNode.position.y - target.position.y
            let distance = sqrt((dx * dx) + (dy * dy))
            
            if distance <= radius {
                enemyNode.takeDamage(finalDamage)
                
                if let gameScene = scene as? GameScene {
                    gameScene.gameManager.trackDamage(Int(finalDamage))
                }
                
                let pushDx = enemyNode.position.x - player.position.x
                let pushDy = enemyNode.position.y - player.position.y
                
                let pushDistance = max(sqrt((pushDx * pushDx) + (pushDy * pushDy)), 1.0)
                
                let nx = pushDx / pushDistance
                let ny = pushDy / pushDistance
                
                let knockbackForce: CGFloat = 20.0
                
                let moveX = nx * knockbackForce
                let moveY = ny * knockbackForce
                
                let pushAction = SKAction.moveBy(x: moveX, y: moveY, duration: 0.15)
                pushAction.timingMode = .easeOut
                
                enemyNode.run(pushAction)
            }
        }
        
        let arcPath = UIBezierPath(arcCenter: .zero,
                                   radius: radius,
                                   startAngle: -.pi / 2,
                                   endAngle: .pi / 2,
                                   clockwise: true)
        
        let slashVisual = SKShapeNode(path: arcPath.cgPath)
        slashVisual.strokeColor = .cyan
        slashVisual.lineWidth = 12.0
        slashVisual.lineCap = .round
        slashVisual.position = target.position
        
        let dxAngle = target.position.x - player.position.x
        let dyAngle = target.position.y - player.position.y
        let baseAngle = atan2(dyAngle, dxAngle)
        slashVisual.zRotation = baseAngle + CGFloat.random(in: -0.8...0.8)
        
        scene.addChild(slashVisual)
        
        slashVisual.setScale(0.5)
        let popIn = SKAction.scale(to: 1.5, duration: 0.05)
        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
        let remove = SKAction.removeFromParent()
        
        slashVisual.run(SKAction.sequence([popIn, fadeOut, remove]))
    }
}
