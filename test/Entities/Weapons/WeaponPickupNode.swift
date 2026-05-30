//
//  WeaponPickupNode.swift
//  test
//
//  Created by Tiago Miranda on 30/05/2026.
//
import SpriteKit


class WeaponPickupNode : SKSpriteNode
{
    let weaponID : String
    
    init(position: CGPoint, weaponID: String)
    {
        self.weaponID = weaponID
        
        super.init(texture: nil, color: .orange, size: CGSize(width: 30, height: 30))
        self.position = position
        
        self.name = "pickup_\(weaponID)"
        
        setupPhysics()
        
        let pulseUp = SKAction.scale(to: 1.2, duration: 0.5)
        let pulseDown = SKAction.scale(to: 1.0, duration: 0.5)
        self.run(SKAction.repeatForever(SKAction.sequence([pulseUp,pulseDown])))
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("Init(coder: has not been implemented")
    }
    
    private func setupPhysics()
    {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategories.powerUp
        self.physicsBody?.contactTestBitMask = PhysicsCategories.player
        self.physicsBody?.collisionBitMask = PhysicsCategories.none
    }
}
