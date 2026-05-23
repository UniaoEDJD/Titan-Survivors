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
    var attackRange: Double = 10.0
    
    private var timeSinceLastAttack: TimeInterval = 0
    
    func update(dt: TimeInterval, player: SKNode, scene: SKNode, globalDamageMult: Double)
    {
        
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
    
    private func fireSlash(from player: SKNode, towards target: SKNode, scene: SKScene, multiplier: Double)
    {
        let dx = target.position.x - player.position.x
        let dy = target.position.y - player.position.y
        let angle = atan2(dy, dx)
        
        let slash = SKShapeNode(rectOf: CGSize(width: 60, height: 10), cornerRadius: 5)
        slash.fillColor = .white
        slash.strokeColor = .cyan
        
        let offsetDistance: CGFloat = 30.0
                slash.position = CGPoint(
                    x: player.position.x + cos(angle) * offsetDistance,
                    y: player.position.y + sin(angle) * offsetDistance
                )
        slash.zRotation = angle
        
        slash.physicsBody = SKPhysicsBody(rectangleOf: slash.frame.size)
        slash.physicsBody?.isDynamic = false
        
        scene.addChild(slash)
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
        let remove = SKAction.removeFromParent()
                
        slash.run(SKAction.sequence([scaleUp, fadeOut, remove]))
    }
}

