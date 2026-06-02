import Foundation

enum GameState{
    case playing
    case levelUpMenu
    case gameOver
    case victory
}

class GameManager{
    private(set) var currentState: GameState = .playing
    private(set) var runTime: TimeInterval = 0.0
    private let maxRunTime: TimeInterval = 900.0
    
    private(set) var playerLevel: Int = 1
    private(set) var currentXp: Int = 0
    private(set) var xpToNextLevel: Int = 5
    private(set) var totalDamageDealt: Int = 0
    
    var onLevelUp: (() -> Void )?
    var onGameOver: (() -> Void)?
    var onVictory: (() -> Void)?
    var onXpUpdated:((Int, Int) -> Void)?
    
    func trackDamage(_ amount: Int){
        guard currentState == .playing else { return }
        totalDamageDealt += amount
    }
    
    func update(dt: TimeInterval)
    {
        guard currentState == .playing else { return }
        
        runTime += dt
        
        if runTime >= maxRunTime
        {
            triggerVictory()
        }
    }
    
    func gainXp(xpAmount: Int) {
        guard currentState == .playing else { return }
        
        currentXp += xpAmount
        
        if currentXp >= xpToNextLevel
        {
            triggerLevelUp()
        }
        onXpUpdated?(currentXp, xpToNextLevel)
    }
    
    func triggerLevelUp(){
        currentState = .levelUpMenu
        playerLevel += 1
        
        currentXp -= xpToNextLevel
        
        xpToNextLevel = Int(Double(xpToNextLevel) * 1.35)
        
        onLevelUp?()
    }
    
    func resumeLevelUp(){
        currentState = .playing
        
        if currentXp >= xpToNextLevel {
            triggerLevelUp()
        }
    }
    
    func triggerGameOver(){
        currentState = .gameOver
        onGameOver?()
    }
    
    func triggerVictory(){
        currentState = .victory
        onVictory?()
    }
}
