import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private var levelUpView: LevelUpView!
    private var pauseMenuView: PauseMenuView!
    private var gameOverView: GameOverView!
    private var gameVictoryView: GameVictoryView!
    
    override func loadView()
    {
        self.view = SKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLevelUpView()
        setupPauseUI()
        setupPauseButton()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            
            scene.requestLevelUpUI = { [weak self] options in
                self?.showLevelUpScreen(with: options)
            }
            
            scene.requestGameOverUI = { [weak self] (runTime, playerLevel, totalDamageDealt) in
                self?.showGameOverScreen(time: runTime, level: playerLevel, damage: totalDamageDealt)
            }
            scene.requestVictoryUI = { [weak self] (playerLevel, totalDamageDealt) in
                self?.showVictoryScreen(level: playerLevel, damage: totalDamageDealt)
            }
            levelUpView.onUpgradeSelected = { [weak self, weak scene] pickedUpgrade in
                self?.levelUpView.isHidden = true
                scene?.resumeGame(afterPicking: pickedUpgrade)
            }
            
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            setupDevCheatButton(for: scene)
            setupDashButton(for: scene)
            setupGameOverUI()
            setupVictoryUI()
        }
    }
    
    private func setupDevCheatButton(for scene: GameScene) {
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
            
            let killBtn = UIButton(type: .system)
            killBtn.setTitle("Kill All", for: .normal)
            killBtn.backgroundColor = .systemPurple
            killBtn.setTitleColor(.white, for: .normal)
            killBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            killBtn.layer.cornerRadius = 8
            killBtn.translatesAutoresizingMaskIntoConstraints = false
            
            let killAction = UIAction { _ in
                print("🛠️ DEV CHEAT: KILL ALL ENEMIES")
                scene.killAllActiveEnemies()
            }
            killBtn.addAction(killAction, for: .touchUpInside)
            
            let bossBtn = UIButton(type: .system)
            bossBtn.setTitle("Spawn Boss", for: .normal)
            bossBtn.backgroundColor = .systemOrange
            bossBtn.setTitleColor(.white, for: .normal)
            bossBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            bossBtn.layer.cornerRadius = 8
            bossBtn.translatesAutoresizingMaskIntoConstraints = false
            
            let bossAction = UIAction { _ in
                print("🛠️ DEV CHEAT: SPAWN BOSS EVENT")
                scene.spawnManager.spawnBossEvent(around: scene.player.position, multiplier: 1.0)
            }
            bossBtn.addAction(bossAction, for: .touchUpInside)
            
            view.addSubview(xpBtn)
            view.addSubview(killBtn)
            view.addSubview(bossBtn)
            
            NSLayoutConstraint.activate([
                xpBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
                xpBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                xpBtn.widthAnchor.constraint(equalToConstant: 100),
                xpBtn.heightAnchor.constraint(equalToConstant: 40),
                
                killBtn.topAnchor.constraint(equalTo: xpBtn.bottomAnchor, constant: 10),
                killBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                killBtn.widthAnchor.constraint(equalToConstant: 100),
                killBtn.heightAnchor.constraint(equalToConstant: 40),
                
                bossBtn.topAnchor.constraint(equalTo: killBtn.bottomAnchor, constant: 10),
                bossBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                bossBtn.widthAnchor.constraint(equalToConstant: 100),
                bossBtn.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
    
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
    
    private func setupDashButton(for scene: GameScene) {
            let dashBtn = UIButton(type: .system)
            
            dashBtn.setTitle("DASH", for: .normal)
            dashBtn.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            dashBtn.setTitleColor(.white, for: .normal)
            dashBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            dashBtn.layer.cornerRadius = 35
            dashBtn.layer.borderWidth = 2
            dashBtn.layer.borderColor = UIColor.cyan.cgColor
            dashBtn.translatesAutoresizingMaskIntoConstraints = false
            
            let action = UIAction { _ in
                scene.player.performDash(joystickVel: scene.joystick.velocity)
            }
            dashBtn.addAction(action, for: .touchDown)
            
            view.addSubview(dashBtn)
            
            NSLayoutConstraint.activate([
                dashBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                dashBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
                dashBtn.widthAnchor.constraint(equalToConstant: 70),
                dashBtn.heightAnchor.constraint(equalToConstant: 70)
            ])
        }
    
        private func setupPauseUI() {
            pauseMenuView = PauseMenuView()
            pauseMenuView.isHidden = true
            pauseMenuView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(pauseMenuView)
            
            NSLayoutConstraint.activate([
                pauseMenuView.topAnchor.constraint(equalTo: view.topAnchor),
                pauseMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                pauseMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pauseMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            pauseMenuView.onResumeSelected = { [weak self] in
                self?.togglePauseGame()
            }
            
            pauseMenuView.onQuitSelected = { [weak self] in
                self?.dismiss(animated: true)
            }
        }
        
        private func setupPauseButton() {
            let pauseBtn = UIButton(type: .system)
            
            let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
            pauseBtn.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: config), for: .normal)
            
            pauseBtn.tintColor = .white
            pauseBtn.layer.shadowColor = UIColor.black.cgColor
            pauseBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
            pauseBtn.layer.shadowOpacity = 0.6
            pauseBtn.layer.shadowRadius = 4
            
            pauseBtn.translatesAutoresizingMaskIntoConstraints = false
            
            pauseBtn.addAction(UIAction { [weak self] _ in
                self?.togglePauseGame()
            }, for: .touchUpInside)
            
            view.addSubview(pauseBtn)
            
            NSLayoutConstraint.activate([
                pauseBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                pauseBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                pauseBtn.widthAnchor.constraint(equalToConstant: 50),
                pauseBtn.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        private func togglePauseGame() {
            guard let skView = view as? SKView, let scene = skView.scene else { return }
            
            if scene.isPaused {
                UIView.animate(withDuration: 0.2, animations: { self.pauseMenuView.alpha = 0 }) { _ in
                    self.pauseMenuView.isHidden = true
                    scene.isPaused = false
                }
            } else {
                scene.isPaused = true
                pauseMenuView.alpha = 0
                pauseMenuView.isHidden = false
                
                UIView.animate(withDuration: 0.2) { self.pauseMenuView.alpha = 1 }
            }
        }
    
        private func setupGameOverUI() {
            gameOverView = GameOverView()
            gameOverView.isHidden = true
            gameOverView.alpha = 0
            gameOverView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(gameOverView)
            
            NSLayoutConstraint.activate([
                gameOverView.topAnchor.constraint(equalTo: view.topAnchor),
                gameOverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                gameOverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                gameOverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            gameOverView.onRestartSelected = { [weak self] in
                guard let window = self?.view.window else { return }
                window.rootViewController = GameViewController()
            }
            
            gameOverView.onQuitSelected = { [weak self] in
                guard let window = self?.view.window else { return }
                window.rootViewController = MainMenuViewController()
            }
            gameOverView.translatesAutoresizingMaskIntoConstraints = false
        }
        
    private func showGameOverScreen(time: TimeInterval, level: Int, damage: Int) {
        gameOverView.configureStats(runTime: time, level: level, damage: damage)
        gameOverView.isHidden = false
        
        UIView.animate(withDuration: 0.5) {
            self.gameOverView.alpha = 1
        }
    }
    
        private func setupVictoryUI() {
            gameVictoryView = GameVictoryView()
            gameVictoryView.isHidden = true
            gameVictoryView.alpha = 0
            gameVictoryView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(gameVictoryView)
            
            NSLayoutConstraint.activate([
                gameVictoryView.topAnchor.constraint(equalTo: view.topAnchor),
                gameVictoryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                gameVictoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                gameVictoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            
            gameVictoryView.onReturnToMenuSelected = { [weak self] in
                guard let window = self?.view.window else { return }
                window.rootViewController = MainMenuViewController()
            }
        }
        
        private func showVictoryScreen(level: Int, damage: Int) {
            gameVictoryView.configureStats(level: level, damage: damage)
            
            gameVictoryView.isHidden = false
            UIView.animate(withDuration: 0.8) {
                self.gameVictoryView.alpha = 1
            }
        }
}
