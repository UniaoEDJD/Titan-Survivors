import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        let bgImage = UIImageView(image: UIImage(named: "freedom"))
        bgImage.contentMode = .scaleAspectFill
        bgImage.clipsToBounds = true
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bgImage)

        let titleLabel = UILabel()
        titleLabel.text = "TITAN SURVIVORS"
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 54)
        titleLabel.textColor = UIColor(red: 0.6, green: 0.05, blue: 0.05, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowRadius = 6.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 20
        buttonStack.alignment = .fill
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)

        let scoutGreen = UIColor(red: 0.12, green: 0.30, blue: 0.18, alpha: 0.9)
        let startBtn = createStyledButton(title: "START RUN", color: scoutGreen)

        startBtn.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)

        buttonStack.addArrangedSubview(startBtn)

        NSLayoutConstraint.activate([
            bgImage.topAnchor.constraint(equalTo: view.topAnchor),
            bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            buttonStack.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    private func createStyledButton(title: String, color: UIColor) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 24)
        btn.backgroundColor = color
        
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowRadius = 4
        btn.layer.shadowOpacity = 0.5
        
        btn.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        return btn
    }

    @objc private func startGameTapped() {
        print("⚔️ A iniciar a batalha!")
        
        let gameVC = GameViewController()
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.modalTransitionStyle = .crossDissolve
        
        present(gameVC, animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
