//
//  DualBlades.swift
//  test
//
//  Created by Tiago Miranda on 20/05/2026.
//
import SpriteKit

class DualBlades: Weapon{
    
    var cooldown: TimeInterval = 1.2
    var damage: Double = 670.0
    var attackRange: Double = 150.0
    
    private var timeSinceLastAttack: TimeInterval = 0
    
    func update(dt: TimeInterval, player: SKNode, scene: SKNode, globalDamageMult: Double)
    {
        timeSinceLastAttack += dt
        
        if timeSinceLastAttack >= cooldown {
            // Because your protocol uses SKNode, we cast it to SKScene for your helper functions
            if let gameScene = scene as? SKScene {
                if let target = getClosestEnemy(to: player, in: gameScene) {
                    fireSlash(from: player, towards: target, scene: gameScene, multiplier: globalDamageMult)
                    timeSinceLastAttack = 0 // Reset cooldown only when we actually fire!
                }
            }
        }
    }
    
    
    func getClosestEnemy(to player: SKNode, in scene: SKScene) -> SKNode? {
        
        let activeEnemies = scene.children.filter {$0.name == "enemy" && !$0.isHidden}
        
        var closestEnemy: SKNode? = nil
        var shortestDistance: CGFloat = attackRange
        
        for enemy in activeEnemies {
            var dx = player.position.x - enemy.position.x
            var dy = player.position.y - enemy.position.y
            
            let distance  = sqrt((dx * dx) + (dy * dy))
            
            if distance < shortestDistance
            {
                shortestDistance = distance
                closestEnemy = enemy
            }
        }
        return closestEnemy
    }
    private func fireSlash(from player: SKNode, towards target: SKNode, scene: SKScene, multiplier: Double) {
            
            let radius: CGFloat = 40.0 // Made it slightly bigger to feel better!
            let finalDamage = self.damage * multiplier
            
            // 1. PURE MATH AoE DAMAGE (No physics bodies!)
            // Grab all active enemies in the scene
            let allEnemies = scene.children.filter { $0.name == "enemy" && !$0.isHidden }
            
            for enemy in allEnemies {
                // Calculate distance from the center of the slash to this enemy
                let dx = enemy.position.x - target.position.x
                let dy = enemy.position.y - target.position.y
                let distance = sqrt((dx * dx) + (dy * dy))
                
                            if distance <= radius {
                                if let enemyNode = enemy as? EnemyNode {
                                    enemyNode.takeDamage(finalDamage)
                                    
                                    let pushDx = enemyNode.position.x - player.position.x
                                    let pushDy = enemyNode.position.y - player.position.y
                                    
                                    let pushDistance = max(sqrt((pushDx * pushDx) + (pushDy * pushDy)), 1.0)
                                    
                                    let nx = pushDx / pushDistance
                                    let ny = pushDy / pushDistance
                                    
                                    let knockbackForce: CGFloat = 20.0 // Adjust this to make it feel heavier or lighter
                                    
                                    let moveX = nx * knockbackForce
                                    let moveY = ny * knockbackForce
                                    
                                    // If you want them pushed sideways instead, uncomment these two lines:
                                    // let moveX = -ny * knockbackForce
                                    // let moveY = nx * knockbackForce
                                    
                                    let pushAction = SKAction.moveBy(x: moveX, y: moveY, duration: 0.15)
                                    pushAction.timingMode = .easeOut // Crucial for game feel: starts fast, slows down smoothly
                                    
                                    enemyNode.run(pushAction)
                                }
                            }
            }
            
            // 2. THE VISUALS (Purely cosmetic, no physics attached)
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
            
            // 3. Animate and destroy
            slashVisual.setScale(0.5)
            let popIn = SKAction.scale(to: 1.5, duration: 0.05)
            let fadeOut = SKAction.fadeOut(withDuration: 0.15)
            let remove = SKAction.removeFromParent()
            
            slashVisual.run(SKAction.sequence([popIn, fadeOut, remove]))
        }
}
