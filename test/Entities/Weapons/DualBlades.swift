import SpriteKit

class DualBlades: Weapon {
    
    var cooldown: TimeInterval = 1.2
    var damage: Double = 670.0
    var attackRange: Double = 150.0
    
    private var timeSinceLastAttack: TimeInterval = 0
    
    func update(dt: TimeInterval, player: SKNode, scene: SKNode, globalDamageMult: Double) {
        timeSinceLastAttack += dt
        
        if timeSinceLastAttack >= cooldown {
            // Convertemos para SKScene para usar as funções auxiliares
            if let gameScene = scene as? SKScene {
                if let target = getClosestEnemy(to: player, in: gameScene) {
                    fireSlash(from: player, towards: target, scene: gameScene, multiplier: globalDamageMult)
                    timeSinceLastAttack = 0 // Reset do cooldown apenas quando disparamos!
                }
            }
        }
    }
    
    func getClosestEnemy(to player: SKNode, in scene: SKScene) -> EnemyNode? {
        
        // A MAGIA ACONTECE AQUI:
        // 1. O compactMap tenta converter todos os nodes da scene para EnemyNode.
        // 2. Ignora tudo o que não for um EnemyNode (ex: Player, Gemas, UI).
        // 3. O filter garante que só olhamos para os que estão vivos (não escondidos).
        let activeEnemies = scene.children.compactMap { $0 as? EnemyNode }.filter { !$0.isHidden }
        
        var closestEnemy: EnemyNode? = nil
        var shortestDistance: CGFloat = attackRange
        
        for enemy in activeEnemies {
            let dx = player.position.x - enemy.position.x
            let dy = player.position.y - enemy.position.y
            
            let distance = sqrt((dx * dx) + (dy * dy))
            
            if distance < shortestDistance {
                shortestDistance = distance
                closestEnemy = enemy
            }
        }
        return closestEnemy
    }
    
    private func fireSlash(from player: SKNode, towards target: SKNode, scene: SKScene, multiplier: Double) {
        
        let radius: CGFloat = 40.0
        let finalDamage = self.damage * multiplier
        
        // Apanhamos todos os inimigos vivos baseados na classe e não no nome de texto
        let allEnemies = scene.children.compactMap { $0 as? EnemyNode }.filter { !$0.isHidden }
        
        for enemyNode in allEnemies {
            // Calcula a distância do centro do corte até a este inimigo
            let dx = enemyNode.position.x - target.position.x
            let dy = enemyNode.position.y - target.position.y
            let distance = sqrt((dx * dx) + (dy * dy))
            
            if distance <= radius {
                // Aplicamos o dano diretamente:
                enemyNode.takeDamage(finalDamage)
                
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
        
        // Animação e destruição do visual
        slashVisual.setScale(0.5)
        let popIn = SKAction.scale(to: 1.5, duration: 0.05)
        let fadeOut = SKAction.fadeOut(withDuration: 0.15)
        let remove = SKAction.removeFromParent()
        
        slashVisual.run(SKAction.sequence([popIn, fadeOut, remove]))
    }
}
