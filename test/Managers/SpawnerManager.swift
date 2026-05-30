import CoreGraphics
import SpriteKit

class SpawnerManager{
    
    private weak var objectPool : ObjectPool?
    private weak var scene: SKScene?
    
    private var lastSpawn : TimeInterval = 0
    private var currentSpawnInterval : TimeInterval = 2.0
    private let spawnRadius:CGFloat = 600.0
    
    private var spawnChance: [(type: TitanType, chance: Int)] = []
    
    private var lastHealSpawn: TimeInterval = 0
    private var healSpawnInterval: TimeInterval = 20.0
    
    init (objectPool: ObjectPool, scene: SKScene)
    {
        self.objectPool = objectPool
        self.scene = scene
    }
    
    func update(dt: TimeInterval, runTime: TimeInterval, playerPos: CGPoint){
        updateDifficulty(runTime: runTime)
        
        lastSpawn += dt
        if lastSpawn >= currentSpawnInterval {
            spawnEnemy(around: playerPos)
            lastSpawn = 0
        }
        
        lastHealSpawn += dt
        if lastHealSpawn >= healSpawnInterval {
            spawnHealPickup(around: playerPos)
            lastHealSpawn = 0
        }
    }
    
    private func updateDifficulty(runTime: TimeInterval)
    {
        //FASE 3 - apartir 10 min
        if runTime >= 600{
            currentSpawnInterval = 0.2
            spawnChance = [
                (.normal, 20),
                (.abnormal, 50),
                (.crawler, 30)
            ]
        }
        //FASE 2 - apartir 5 min
        else if runTime >= 300{
            currentSpawnInterval = 0.8
            spawnChance = [
                (.normal, 60),
                (.abnormal, 20),
                (.crawler, 20)
            ]
        }
        //FASE 1.5 - apartir 2 min
        else if runTime >= 120{
            currentSpawnInterval = 1.2
            spawnChance = [
                (.normal, 85),
                (.crawler, 15)
            ]
        }
        //FASE 1 - inicio jogo
        else{
            currentSpawnInterval = 2.0
            spawnChance = [
                (.normal, 100)
            ]
        }
    }
    
    private func spawnEnemy(around playerPos: CGPoint)
    {
        let randomAngle = CGFloat.random(in: 0...(2 * .pi))
        let spawnX = playerPos.x + (cos(randomAngle) * spawnRadius)
        let spawnY = playerPos.y + (sin(randomAngle) * spawnRadius)
        let spawnPoint = CGPoint(x: spawnX, y: spawnY)
        
        let selectedType = rollEnemyType()
        
        if selectedType == .crawler {
            _ = objectPool?.spawn(type: .crawler, at: spawnPoint)
            
            let offset1 = CGPoint(x: spawnPoint.x + 30, y: spawnPoint.y + 30)
            let offset2 = CGPoint(x: spawnPoint.x - 30, y: spawnPoint.y - 30)
            
            _ = objectPool?.spawn(type: .crawler, at: offset1)
            _ = objectPool?.spawn(type: .crawler, at: offset2)
        }
        else{
            _ = objectPool?.spawn(type: selectedType, at: spawnPoint)
        }
        print("Spawned enemy")
    }
    
    private func spawnHealPickup(around playerPos: CGPoint)
    {
        let randomAngle = CGFloat.random(in: 0...(2 * .pi))
            
        let spawnX = playerPos.x + (cos(randomAngle) * spawnRadius)
        let spawnY = playerPos.y + (sin(randomAngle) * spawnRadius)
            
        let healNode = HealthPickupNode(healAmount: 200)
        healNode.position = CGPoint(x: spawnX, y: spawnY)
        healNode.zPosition = 1
            
        scene?.addChild(healNode)
        print("❤️ Item de cura plantado no mapa!")
    }
    
    private func rollEnemyType() -> TitanType{
        let totalWeight = spawnChance.reduce(0) { $0 + $1.chance }
        let roll = Int.random(in: 0..<totalWeight)
        
        var currentSum = 0
        for item in spawnChance{
            currentSum += item.chance
            if roll < currentSum {
                return item.type
            }
        }
        return .normal
    }
}
