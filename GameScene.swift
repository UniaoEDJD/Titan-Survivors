//
//  GameScene.swift
//  TouchingSquares
//
//  Created by Gonçalo Araújo on 18/03/2026.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var square : SKSpriteNode!
    var scoreLabel : SKLabelNode!
    var score: Int = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        square = SKSpriteNode(color: .blue, size: CGSize(width: 70, height: 70))
        square.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(square)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontColor = .black
        scoreLabel.fontSize = 32
        scoreLabel.position = CGPoint(x: size.width - 80, y: size.height - 80)
        addChild(scoreLabel)
        
        let wait = SKAction.wait(forDuration: 1.0)
        let move = SKAction.run {self.moveSquare()}
        
        run(SKAction.repeatForever(SKAction.sequence([wait, move])))
    }
    
    func moveSquare() {
        let x = CGFloat.random(in: square.size.width/2 ..< size.width - square.size.width-2)
        let y = CGFloat.random(in: square.size.height/2 ..< size.height - square.size.height-2)
        square.position = CGPoint(x: x, y: y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first else { return }
        let location = touchLocation.location(in: self)
        
        if (square.contains(location)){
            score += 1
            scoreLabel.text = "Score: \(score)"
            moveSquare( )
        }
    }
}
