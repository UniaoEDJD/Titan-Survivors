//
//  GameManager.swift
//  test
//
//  Created by Gonçalo Araújo on 08/05/2026.
//
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
    
    var onLevelUp: (() -> Void )?
    var onGameOver: (() -> Void)?
    var onVictory: (() -> Void)?
    
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
