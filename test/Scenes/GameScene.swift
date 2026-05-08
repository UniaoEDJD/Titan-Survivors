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
    
    let playerSpeed: CGFloat = 5.0
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupPlayer()
        setupCamera()
        setupJoystick()
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
            let xPos = -(size.width / 2) + 100
            let yPos = -(size.height / 2) + 100
            joystick.position = CGPoint(x: xPos, y: yPos)
            
            // ATENÇÃO: Adicionar à câmara para ficar sempre visível!
            cameraNode.addChild(joystick)
        }
        override func update(_ currentTime: TimeInterval) {
            // 1. Atualizar a posição do jogador com base no joystick
            if joystick.velocity != .zero {
                player.position.x += joystick.velocity.x * playerSpeed
                player.position.y += joystick.velocity.y * playerSpeed
            }
            
            // 2. A câmara persegue a posição do jogador
            cameraNode.position = player.position
        }
}
