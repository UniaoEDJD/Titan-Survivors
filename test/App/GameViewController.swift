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
            // 1. Botão +100 XP
            let xpBtn = UIButton(type: .system)
            xpBtn.setTitle("+100 XP", for: .normal)
            xpBtn.backgroundColor = .systemRed
            xpBtn.setTitleColor(.white, for: .normal)
            xpBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            xpBtn.layer.cornerRadius = 8
            xpBtn.translatesAutoresizingMaskIntoConstraints = false
            
            let xpAction = UIAction { _ in
                print("🛠️ DEV CHEAT: +100 XP")
                scene.gameManager.gainXp(xpAmount: 100)
            }
            xpBtn.addAction(xpAction, for: .touchUpInside)
            
            // 2. Botão Kill All
            let killBtn = UIButton(type: .system)
            killBtn.setTitle("Kill All", for: .normal)
            killBtn.backgroundColor = .systemPurple // Cor diferente para distinguir
            killBtn.setTitleColor(.white, for: .normal)
            killBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            killBtn.layer.cornerRadius = 8
            killBtn.translatesAutoresizingMaskIntoConstraints = false
            
            let killAction = UIAction { _ in
                print("🛠️ DEV CHEAT: KILL ALL ENEMIES")
                scene.killAllActiveEnemies()
            }
            killBtn.addAction(killAction, for: .touchUpInside)
            
            // Adicionar à View
            view.addSubview(xpBtn)
            view.addSubview(killBtn)
            
            // Constraints para ficarem no canto superior direito, um debaixo do outro
            NSLayoutConstraint.activate([
                // Botão XP no topo
                xpBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                xpBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                xpBtn.widthAnchor.constraint(equalToConstant: 100),
                xpBtn.heightAnchor.constraint(equalToConstant: 40),
                
                // Botão Kill All logo abaixo do botão de XP
                killBtn.topAnchor.constraint(equalTo: xpBtn.bottomAnchor, constant: 10),
                killBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                killBtn.widthAnchor.constraint(equalToConstant: 100),
                killBtn.heightAnchor.constraint(equalToConstant: 40)
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
