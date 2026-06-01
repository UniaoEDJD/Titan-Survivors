import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        // Podes no futuro adicionar uma imagem de fundo épica:
        // let bgImage = UIImageView(image: UIImage(named: "menu_bg"))
        // bgImage.contentMode = .scaleAspectFill
        // bgImage.frame = view.bounds
        // view.addSubview(bgImage)

        let titleLabel = UILabel()
        titleLabel.text = "TITAN SURVIVORS"
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 54)
        titleLabel.textColor = .systemRed // Vermelho sangue
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowRadius = 4.0
        titleLabel.layer.shadowOpacity = 0.8
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // 3. StackView para organizar os botões verticalmente
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 20
        buttonStack.alignment = .fill
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)

        // 4. Criar os botões temáticos
        let startBtn = createStyledButton(title: "START RUN", color: UIColor(red: 0.2, green: 0.6, blue: 0.3, alpha: 1.0)) // Verde Tropa
        let optionsBtn = createStyledButton(title: "OPTIONS", color: .darkGray)

        // Adicionar a ação ao botão de Start
        startBtn.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)

        // Adicionar à Stack
        buttonStack.addArrangedSubview(startBtn)
        buttonStack.addArrangedSubview(optionsBtn)

        // 5. Constraints (Regras de posicionamento automático)
        NSLayoutConstraint.activate([
            // Título colado ao topo
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Botões centrados no ecrã
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
        
        // Estilo e bordas
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
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
