//
//  SpawnerManager.swift
//  test
//
//  Created by Gonçalo Araújo on 08/05/2026.
//
import CoreGraphics
import SpriteKit

class SpawnerManager{
    
    private weak var objectPool : ObjectPool?
    
    private var lastSpawn : TimeInterval = 0
    private var currentSpawnInterval : TimeInterval = 2.0
    
    private let spawnRadius:CGFloat = 600.0
    
    init (objectPool: ObjectPool)
    {
        self.objectPool = objectPool
    }
    
    func update(dt: TimeInterval, runTime: TimeInterval, playerPos: CGPoint){
        updateDifficulty(runTime: runTime)
        
        lastSpawn += dt
        
        if lastSpawn >= currentSpawnInterval {
            spawnEnemy(around: playerPos)
            lastSpawn = 0
        }
    }
    
    func updateDifficulty(runTime: TimeInterval)
    {
        if runTime >= 600
        {
            currentSpawnInterval = 0.2
        }
        else if runTime >= 300
        {
            currentSpawnInterval = 0.8
        }
        else
        {
            currentSpawnInterval = 2.0
        }
    }
    
    private func spawnEnemy(around playerPos: CGPoint)
    {
        let randomAngle = CGFloat.random(in: 0...(2 * .pi))
        
        let spawnX = playerPos.x + (cos(randomAngle) * spawnRadius)
        let spawnY = playerPos.y + (sin(randomAngle) * spawnRadius)
        
        let spawnPoint = CGPoint(x: spawnX, y: spawnY)
        
        _ = objectPool?.spawn(at: spawnPoint)
        print("Spawned enemy")
    }
}
