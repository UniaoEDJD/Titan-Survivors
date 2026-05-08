//
//  ObjectPoolManager.swift
//  test
//
//  Created by Gonçalo Araújo on 08/05/2026.
//
import SpriteKit

class ObjectPool{
    private var pool: [SKSpriteNode] = []
    
    init(capacity: Int, scene: SKScene)
    {
        for _ in 0..<capacity {
            let enemy = SKSpriteNode(color: .red, size: CGSize(width: 20, height: 20))
            enemy.name = "enemy"
            
            enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
            enemy.physicsBody?.isDynamic = false
            
            enemy.isHidden = true
            enemy.physicsBody?.categoryBitMask = 0
            
            scene.addChild(enemy)
            
            pool.append(enemy)
        }
    }
    
    func spawn(at position: CGPoint) -> SKSpriteNode? {
        if let availableEnemy = pool.first(where: {$0.isHidden}) {
            
            availableEnemy.position = position
            availableEnemy.isHidden = false
            
            availableEnemy.physicsBody?.categoryBitMask = 1
            
            return availableEnemy
            
        }
        return nil
    }
    
    func despawn(_ node: SKSpriteNode) {
        node.isHidden = true
        node.physicsBody?.categoryBitMask = 0
        node.removeAllActions()
    }
}

