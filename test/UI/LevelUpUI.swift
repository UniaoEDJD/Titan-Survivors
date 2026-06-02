import UIKit

class LevelUpView: UIView {
    
    var onUpgradeSelected: ((UpgradeOption) -> Void)?
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        titleLabel.text = "LEVEL UP"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            stackView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func displayUpgrades(_ options: [UpgradeOption]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for option in options {
            let cardBtn = createCardButton(for: option)
            stackView.addArrangedSubview(cardBtn)
        }
    }
    
    private func createCardButton(for option: UpgradeOption) -> UIButton {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor.darkGray
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.systemYellow.cgColor
        
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.textAlignment = .center
        
        let cardText = """
        [\(option.rarity.rawValue)]
        
        \(option.title)
        
        \(option.description)
        """
        btn.setTitle(cardText, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        let action = UIAction { [weak self] _ in
            self?.onUpgradeSelected?(option)
        }
        btn.addAction(action, for: .touchUpInside)
        
        return btn
    }
}
