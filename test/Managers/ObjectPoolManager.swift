import SpriteKit

enum TitanType {
    case normal, abnormal, crawler
}

class ObjectPool{
    private var normalPool: [EnemyNode] = []
    private var abnormalPool: [EnemyNode] = []
    private var crawlerPool: [EnemyNode] = []
    
    private weak var player: SKSpriteNode?
    
    init(scene: SKScene, player: SKSpriteNode)
    {
        self.player = player
        
        //preload dos inimigos
        preload(type: .normal, count: 300, scene: scene)
        preload(type: .abnormal, count: 100, scene: scene)
        preload(type: .crawler, count: 100, scene: scene)
    }
    
    private func preload(type: TitanType, count: Int, scene: SKScene) {
            for _ in 0..<count {
                let enemy: EnemyNode
                
                // Decidir qual classe instanciar
                switch type {
                case .normal: enemy = NormalTitan()
                case .abnormal: enemy = AbnormalTitan()
                case .crawler: enemy = CrawlerTitan()
                }
                
                enemy.isHidden = true
                enemy.physicsBody?.isDynamic = false
                enemy.position = CGPoint(x: 10000, y: 10000)
                
                // Lógica do Drop de XP usa o xpReward dinâmico de cada inimigo!
                enemy.onDeath = { [weak scene, weak enemy] dropPosition in
                    guard let reward = enemy?.xpReward else { return }
                    let gem = ExperienceNode(value: reward)
                    gem.position = dropPosition
                    scene?.addChild(gem)
                }
                
                scene.addChild(enemy)
                
                // Guardar na respetiva gaveta
                switch type {
                case .normal: normalPool.append(enemy)
                case .abnormal: abnormalPool.append(enemy)
                case .crawler: crawlerPool.append(enemy)
                }
            }
        }
    
    func spawn(type: TitanType, at position: CGPoint) -> EnemyNode? {
        let poolToSearch: [EnemyNode]
        
        switch type {
        case .normal: poolToSearch = normalPool
        case .abnormal: poolToSearch = abnormalPool
        case .crawler: poolToSearch = crawlerPool
        }
        
        if let availableEnemy = poolToSearch.first(where: { $0.isHidden }), let targe = player {
            availableEnemy.spawn(at: position, target: targe)
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
        return normalPool + abnormalPool + crawlerPool
    }
}

