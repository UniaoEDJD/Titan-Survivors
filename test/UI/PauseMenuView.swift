import UIKit

class PauseMenuView: UIView {
    
    var onResumeSelected: (() -> Void)?
    var onQuitSelected: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.85)
        
        let titleLabel = UILabel()
        titleLabel.text = "PAUSED"
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 48)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Botões do Menu
        let resumeBtn = createStyledButton(title: "RESUME", color: UIColor(red: 0.2, green: 0.6, blue: 0.3, alpha: 1.0))
        let optionsBtn = createStyledButton(title: "OPTIONS", color: .darkGray)
        let quitBtn = createStyledButton(title: "QUIT TO MENU", color: .systemRed)
        
        // Ações dos Botões
        resumeBtn.addAction(UIAction { [weak self] _ in self?.onResumeSelected?() }, for: .touchUpInside)
        quitBtn.addAction(UIAction { [weak self] _ in self?.onQuitSelected?() }, for: .touchUpInside)
        
        // Organizar na vertical (StackView)
        let stack = UIStackView(arrangedSubviews: [resumeBtn, optionsBtn, quitBtn])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        // Posições no ecrã
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -120),
            
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            stack.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func createStyledButton(title: String, color: UIColor) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        btn.backgroundColor = color
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        btn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        return btn
    }
}
