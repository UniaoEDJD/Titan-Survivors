//
//  Weapon.swift
//  test
//
//  Created by Gonçalo Araújo on 08/05/2026.
//

import SpriteKit

protocol Weapon {
    var cooldown: TimeInterval {get set}
    var damage: Double {get set}
    
    func update(dt: TimeInterval, player: SKNode, scene: SKNode, globalDamageMult: Double)
}
