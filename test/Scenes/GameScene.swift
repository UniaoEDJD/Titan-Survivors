//
//  GameScene.swift
//  test
//
//  Created by Gonçalo Araújo on 06/05/2026.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var player: SKSpriteNode!
    var cameraNode: SKCameraNode!
    var joystick: VirtualJoystick!
    var objectPool: ObjectPool!
    var spawnManager: SpawnerManager!
    
    let upgradeManager = UpgradeManager()
    let gameManager = GameManager()
    let playerSpeed: CGFloat = 5.0
    
    var requestLevelUpUI: (([UpgradeOption]) -> Void)?
    override func didMove(to view: SKView) {
        setupBackground()
        setupPlayer()
        setupCamera()
        setupJoystick()
        
        objectPool = ObjectPool(capacity: 300, scene: self, player: player)
        spawnManager = SpawnerManager(objectPool: objectPool)
        
        gameManager.onLevelUp = { [weak self] in
                    guard let self = self else { return }
                    
                    // 1. Pause the game engine completely
                    self.isPaused = true
                    
                    // 2. Ask the UpgradeManager to roll 3 random cards
                    let draftedCards = self.upgradeManager.rollUpgrades(count: 3)
                    
                    // 3. Send those cards up to the ViewController to display
                    self.requestLevelUpUI?(draftedCards)
                }
    }
    
    func resumeGame(afterPicking upgrade: UpgradeOption) {
            upgradeManager.applyUpgrade(upgrade)
            gameManager.resumeLevelUp()
            self.isPaused = false
        }
    
    func setupBackground() {
        let background = SKSpriteNode(color: SKColor.darkGray, size: CGSize(width: 3000, height: 3000))
        background.zPosition = -1
        addChild(background)
    }
    
    func setupPlayer() {
            // Criar o jogador (um quadrado azul por agora)
            player = SKSpriteNode(color: .systemBlue, size: CGSize(width: 40, height: 40))
            player.position = .zero
            addChild(player)
        }
        
    func setupCamera() {
            cameraNode = SKCameraNode()
            self.camera = cameraNode // Diz à Scene que esta é a câmara principal
            addChild(cameraNode)
    }
        
    func setupJoystick() {
            joystick = VirtualJoystick()
            
            // Posicionar no canto inferior esquerdo do ecrã
            let xPos = -(size.width/2) + 100
            let yPos = -(size.height/2) + 100
            joystick.position = CGPoint(x: xPos, y: yPos)
            
            // ATENÇÃO: Adicionar à câmara para ficar sempre visível!
            cameraNode.addChild(joystick)
    }
    var lastTime : TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        if lastTime == 0 { lastTime = currentTime }
        let delta_time = currentTime - lastTime
        lastTime = currentTime
        
        gameManager.update(dt: delta_time)
        if gameManager.currentState == .playing {
            spawnManager.update(dt: delta_time, runTime: gameManager.runTime, playerPos: player.position)
        }
        // 1. Atualizar a posição do jogador com base no joystick
        if joystick.velocity != .zero {
            player.position.x += joystick.velocity.x * playerSpeed
            player.position.y += joystick.velocity.y * playerSpeed
        }
        // 2. A câmara persegue a posição do jogador
        cameraNode.position = player.position
        for enemy in objectPool.allEnemies {
            enemy.update()
        }
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
            super.didChangeSize(oldSize)
            
            // Esta função é chamada automaticamente quando as dimensões do ecrã atualizam.
            // O "if let" garante que só tentamos mover o joystick SE ele já tiver sido criado no didMove.
            if let joystick = joystick {
                // Aumentei um pouco o xPos para 120 para garantir que não fica escondido atrás da "notch" (entalhe) do iPhone
                let xPos = -(size.width / 2) + 120
                let yPos = -(size.height / 2) + 100
                joystick.position = CGPoint(x: xPos, y: yPos)
            }
        }
}
