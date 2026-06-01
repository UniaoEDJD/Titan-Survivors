import UIKit

class GameOverView: UIView {
    
    var onRestartSelected: (() -> Void)?
    var onQuitSelected: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(red: 0.15, green: 0.0, blue: 0.0, alpha: 0.9)
        
        let titleLabel = UILabel()
        titleLabel.text = "GAME OVER"
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 54)
        titleLabel.textColor = .systemRed
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowRadius = 8.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 6)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Humanity needs you to fight again."
        subtitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 18)
        subtitleLabel.textColor = .lightGray
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtitleLabel)
        
        // Buttons
        let restartBtn = createStyledButton(title: "RESTART RUN", color: UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 1.0))
        let quitBtn = createStyledButton(title: "MAIN MENU", color: .darkGray)
        
        restartBtn.addAction(UIAction { [weak self] _ in self?.onRestartSelected?() }, for: .touchUpInside)
        quitBtn.addAction(UIAction { [weak self] _ in self?.onQuitSelected?() }, for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [restartBtn, quitBtn])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -80),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            stack.widthAnchor.constraint(equalToConstant: 280)
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
        btn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return btn
    }
}
