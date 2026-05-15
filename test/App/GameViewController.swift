//
//  GameViewController.swift
//  test
//
//  Created by Gonçalo Araújo on 06/05/2026.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    // This MUST be up here at the class level, outside of viewDidLoad!
    private var levelUpView: LevelUpView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLevelUpView()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            
            // Hook up the communication bridge
            scene.requestLevelUpUI = { [weak self] options in
                self?.showLevelUpScreen(with: options)
            }
            
            // Handle what happens when a player taps a card
            levelUpView.onUpgradeSelected = { [weak self, weak scene] pickedUpgrade in
                self?.levelUpView.isHidden = true
                scene?.resumeGame(afterPicking: pickedUpgrade)
            }
            
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    private func setupLevelUpView() {
        levelUpView = LevelUpView()
        levelUpView.isHidden = true
        levelUpView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelUpView)
        
        // Make it cover the entire screen
        NSLayoutConstraint.activate([
            levelUpView.topAnchor.constraint(equalTo: view.topAnchor),
            levelUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            levelUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            levelUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func showLevelUpScreen(with options: [UpgradeOption]) {
        levelUpView.displayUpgrades(options)
        
        // Simple fade-in animation
        levelUpView.alpha = 0
        levelUpView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.levelUpView.alpha = 1
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
