import SpriteKit

class ThunderSpears: Weapon {
    var cooldown: TimeInterval = 3.0
    var damage: Double = 1500.0
    var attackRange: Double = 400.0
    weak var upgradeManager: UpgradeManager?
    
    private var timeSinceLastAttack: TimeInterval = 0

    init(upgradeManager: UpgradeManager? = nil) {
        self.upgradeManager = upgradeManager
    }
    
    func update(dt: TimeInterval, player: SKNode, scene: SKNode, globalDamageMult: Double) {
        timeSinceLastAttack += dt

        let state = upgradeManager?.weaponStates["thunderspear"] ?? WeaponUpgradeState()
        let effectiveCooldown = cooldown * state.cooldownMult
        
        if timeSinceLastAttack >= effectiveCooldown {
            if let gameScene = scene as? SKScene {
                if let target = getTargetEnemy(to: player, in: gameScene) {
                    fireSpear(from: player, targetPos: target.position, scene: gameScene, multiplier: globalDamageMult, extraShots: state.extraShots)
                    timeSinceLastAttack = 0
                }
            }
        }
    }
    
    private func getTargetEnemy(to player: SKNode, in scene: SKScene) -> SKNode? {
        let activeEnemies = scene.children.compactMap { $0 as? EnemyNode }.filter { !$0.isHidden }
        var targetEnemy: SKNode? = nil
        var shortestDistance: CGFloat = attackRange
        
        for enemy in activeEnemies {
            let dx = player.position.x - enemy.position.x
            let dy = player.position.y - enemy.position.y
            let distance = sqrt((dx * dx) + (dy * dy))
            
            if distance < shortestDistance {
                shortestDistance = distance
                targetEnemy = enemy
            }
        }
        return targetEnemy
    }
    
    private func fireSpear(from player: SKNode, targetPos: CGPoint, scene: SKScene, multiplier: Double, extraShots: Int) {
        let shots = max(1, extraShots + 1)

        let dxToTarget = targetPos.x - player.position.x
        let dyToTarget = targetPos.y - player.position.y
        let distanceToTarget = sqrt(dxToTarget * dxToTarget + dyToTarget * dyToTarget)
        let flyDistance = distanceToTarget

        for index in 0..<shots {
            let spear = SKSpriteNode(imageNamed: "thunderspear")
            spear.texture?.filteringMode = .nearest
            spear.size = CGSize(width: 30, height: 8)
            spear.position = player.position

            let offset = CGFloat(index) - CGFloat(shots - 1) / 2
            let dx = targetPos.x - player.position.x
            let dy = targetPos.y - player.position.y
            let baseAngle = atan2(dy, dx)
            let angle = baseAngle + offset * 0.12
            spear.zRotation = angle

            scene.addChild(spear)

            let flyTarget = CGPoint(x: player.position.x + cos(angle) * flyDistance, y: player.position.y + sin(angle) * flyDistance)
            let duration = TimeInterval(flyDistance / 800.0)
            let flyAction = SKAction.move(to: flyTarget, duration: duration)

            let explodeAction = SKAction.run { [weak self] in
                self?.triggerExplosion(at: flyTarget, scene: scene, multiplier: multiplier)
            }

            spear.run(SKAction.sequence([flyAction, explodeAction, SKAction.removeFromParent()]))
        }
    }
    
    private func triggerExplosion(at position: CGPoint, scene: SKScene, multiplier: Double) {
        let explosionRadius: CGFloat = 80.0
        let finalDamage = self.damage * multiplier
        
        let blast = SKShapeNode(circleOfRadius: explosionRadius)
        blast.fillColor = UIColor.orange.withAlphaComponent(0.6)
        blast.strokeColor = .red
        blast.position = position
        scene.addChild(blast)
        
        blast.setScale(0.1)
        let expand = SKAction.scale(to: 1.0, duration: 0.1)
        let fade = SKAction.fadeOut(withDuration: 0.2)
        blast.run(SKAction.sequence([expand, fade, SKAction.removeFromParent()]))
        
        let allEnemies = scene.children.compactMap { $0 as? EnemyNode }.filter { !$0.isHidden }

        for enemy in allEnemies {
            let dx = enemy.position.x - position.x
            let dy = enemy.position.y - position.y
            let distance = sqrt((dx * dx) + (dy * dy))
            
            if distance <= explosionRadius {
                 
                    enemy.takeDamage(finalDamage)
                    
                    if let gameScene = scene as? GameScene {
                        gameScene.gameManager.trackDamage(Int(finalDamage))
                }
                    
                    let pushDistance = max(distance, 1.0)
                    let nx = dx / pushDistance
                    let ny = dy / pushDistance
                    let knockbackForce: CGFloat = 35.0
                    
                    let pushAction = SKAction.moveBy(x: nx * knockbackForce, y: ny * knockbackForce, duration: 0.15)
                    pushAction.timingMode = .easeOut
                    enemy.run(pushAction)
                
            }
        }
    }
}
