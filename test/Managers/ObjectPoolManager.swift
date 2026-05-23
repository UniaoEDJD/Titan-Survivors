import SpriteKit

class ObjectPool{
    private var pool: [EnemyNode] = []
    private weak var player: SKSpriteNode?
    
    init(capacity: Int, scene: SKScene, player: SKSpriteNode)
    {
        self.player = player
        
        for _ in 0..<capacity {
            let enemy = NormalTitan()
            enemy.name = "enemy"
            
            enemy.isHidden = true
            enemy.physicsBody?.isDynamic = false
            enemy.position = CGPoint(x: 10000, y: 10000)
            
            //oq acontece quando morre? drop XP
            enemy.onDeath = {[weak scene] dropPosition in
                    let gem = ExperienceNode(value: 1)
                gem.position = dropPosition
                scene?.addChild(gem)
            }
            scene.addChild(enemy)
            pool.append(enemy)
        }
    }
    
    func spawn(at position: CGPoint) -> EnemyNode? {
            if let availableEnemy = pool.first(where: { $0.isHidden }), let target = player {
                availableEnemy.spawn(at: position, target: target)
                return availableEnemy
            }
            return nil
        }
    
    func despawn(_ node: EnemyNode) {
        node.isHidden = true
        node.physicsBody?.isDynamic = false
        node.removeAllActions()
    }
    
    var allEnemies: [EnemyNode] {
        return pool
    }
}

