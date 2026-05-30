//
//  ThunderSpear.swift
//  test
//
//  Created by Tiago Miranda on 30/05/2026.
//

import SpriteKit

class ThunderSpears: Weapon {
    var cooldown: TimeInterval = 3.0 // Fires every 3 seconds
    var damage: Double = 1500.0 // Massive damage
    var attackRange: Double = 400.0 // Ranged!
    
    private var timeSinceLastAttack: TimeInterval = 0
    
    func update(dt: TimeInterval, player: SKNode, scene: SKNode, globalDamageMult: Double) {
        timeSinceLastAttack += dt
        
        if timeSinceLastAttack >= cooldown {
            if let gameScene = scene as? SKScene {
                // Find an enemy to shoot at
                if let target = getTargetEnemy(to: player, in: gameScene) {
                    fireSpear(from: player, targetPos: target.position, scene: gameScene, multiplier: globalDamageMult)
                    timeSinceLastAttack = 0
                }
            }
        }
    }
    
    private func getTargetEnemy(to player: SKNode, in scene: SKScene) -> SKNode? {
        let activeEnemies = scene.children.filter { $0.name == "enemy" && !$0.isHidden }
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
    
    private func fireSpear(from player: SKNode, targetPos: CGPoint, scene: SKScene, multiplier: Double) {
        // 1. Draw the Spear
        let spear = SKShapeNode(rectOf: CGSize(width: 20, height: 4), cornerRadius: 2)
        spear.fillColor = .gray
        spear.strokeColor = .orange
        spear.position = player.position
        
        // Point the spear at the target
        let dx = targetPos.x - player.position.x
        let dy = targetPos.y - player.position.y
        spear.zRotation = atan2(dy, dx)
        
        scene.addChild(spear)
        
        // 2. Animate the flight
        let flyAction = SKAction.move(to: targetPos, duration: 0.4) // Takes 0.4s to hit
        
        // 3. When it lands, trigger the explosion!
        let explodeAction = SKAction.run { [weak self] in
            self?.triggerExplosion(at: targetPos, scene: scene, multiplier: multiplier)
        }
        
        // Fly, Explode, then delete the spear
        spear.run(SKAction.sequence([flyAction, explodeAction, SKAction.removeFromParent()]))
    }
    
    private func triggerExplosion(at position: CGPoint, scene: SKScene, multiplier: Double) {
        let explosionRadius: CGFloat = 80.0
        let finalDamage = self.damage * multiplier
        
        // 1. VISUAL: Big orange blast
        let blast = SKShapeNode(circleOfRadius: explosionRadius)
        blast.fillColor = UIColor.orange.withAlphaComponent(0.6)
        blast.strokeColor = .red
        blast.position = position
        scene.addChild(blast)
        
        blast.setScale(0.1)
        let expand = SKAction.scale(to: 1.0, duration: 0.1)
        let fade = SKAction.fadeOut(withDuration: 0.2)
        blast.run(SKAction.sequence([expand, fade, SKAction.removeFromParent()]))
        
        // 2. PURE MATH AoE DAMAGE (No physics pushing!)
        let allEnemies = scene.children.filter { $0.name == "enemy" && !$0.isHidden }
        
        for enemy in allEnemies {
            let dx = enemy.position.x - position.x
            let dy = enemy.position.y - position.y
            let distance = sqrt((dx * dx) + (dy * dy))
            
            if distance <= explosionRadius {
                if let enemyNode = enemy as? EnemyNode {
                    enemyNode.takeDamage(finalDamage)
                    
                    // Knockback away from the center of the explosion
                    let pushDistance = max(distance, 1.0)
                    let nx = dx / pushDistance
                    let ny = dy / pushDistance
                    let knockbackForce: CGFloat = 35.0 // Bigger knockback for explosions!
                    
                    let pushAction = SKAction.moveBy(x: nx * knockbackForce, y: ny * knockbackForce, duration: 0.15)
                    pushAction.timingMode = .easeOut
                    enemyNode.run(pushAction)
                }
            }
        }
    }
}
