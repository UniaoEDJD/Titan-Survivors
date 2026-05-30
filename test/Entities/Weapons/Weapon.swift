import SpriteKit

protocol Weapon {
    var cooldown: TimeInterval {get set}
    var damage: Double {get set}
    
    func update(dt: TimeInterval, player: SKNode, scene: SKNode, globalDamageMult: Double)
}
