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
            
            // ADD THIS HERE: Hook up the dev cheat button to the scene
            setupDevCheatButton(for: scene)
        }
    }
    
    // MARK: - Dev Cheats
    private func setupDevCheatButton(for scene: GameScene) {
        let cheatBtn = UIButton(type: .system)
        cheatBtn.setTitle("+100 XP", for: .normal)
        cheatBtn.backgroundColor = .systemRed
        cheatBtn.setTitleColor(.white, for: .normal)
        cheatBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cheatBtn.layer.cornerRadius = 8
        cheatBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // This action tells the scene's gameManager to add XP directly!
        let action = UIAction { _ in
            print("🛠️ DEV CHEAT TRIGGERED: +100 XP")
            scene.gameManager.gainXp(xpAmount: 100)
        }
        cheatBtn.addAction(action, for: .touchUpInside)
        
        view.addSubview(cheatBtn)
        
        // Pin it to the top right corner
        NSLayoutConstraint.activate([
            cheatBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cheatBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cheatBtn.widthAnchor.constraint(equalToConstant: 100),
            cheatBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Level Up UI
    private func setupLevelUpView() {
        levelUpView = LevelUpView()
        levelUpView.isHidden = true
        levelUpView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelUpView)
        
        NSLayoutConstraint.activate([
            levelUpView.topAnchor.constraint(equalTo: view.topAnchor),
            levelUpView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            levelUpView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            levelUpView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func showLevelUpScreen(with options: [UpgradeOption]) {
        levelUpView.displayUpgrades(options)
        
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
