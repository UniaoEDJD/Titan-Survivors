import UIKit

class GameOverView: UIView {
    
    var onRestartSelected: (() -> Void)?
    var onQuitSelected: (() -> Void)?
    
    private let bgImage = UIImageView(image: UIImage(named: "sea"))
    private let darkOverlay = UIView()
    private let statsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgImage.frame = self.bounds
        darkOverlay.frame = self.bounds
    }
    
    private func setupUI() {
        self.backgroundColor = .black
        
        bgImage.contentMode = .scaleAspectFill
        bgImage.clipsToBounds = true
        addSubview(bgImage)
        
        darkOverlay.backgroundColor = UIColor(white: 0.0, alpha: 0.55)
        addSubview(darkOverlay)
        
        let titleLabel = UILabel()
        titleLabel.text = "GAME OVER"
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 54)
        titleLabel.textColor = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowRadius = 6.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        statsLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        statsLabel.textColor = UIColor(red: 0.95, green: 0.85, blue: 0.6, alpha: 1.0)
        statsLabel.textAlignment = .center
        statsLabel.numberOfLines = 3
        statsLabel.layer.shadowColor = UIColor.black.cgColor
        statsLabel.layer.shadowRadius = 4.0
        statsLabel.layer.shadowOpacity = 0.9
        statsLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statsLabel)
        
        let restartBtn = createStyledButton(title: "RESTART RUN", color: UIColor(red: 0.55, green: 0.08, blue: 0.08, alpha: 0.9))
        let quitBtn = createStyledButton(title: "MAIN MENU", color: UIColor(white: 0.15, alpha: 0.75))
        
        restartBtn.addAction(UIAction { [weak self] _ in self?.onRestartSelected?() }, for: .touchUpInside)
        quitBtn.addAction(UIAction { [weak self] _ in self?.onQuitSelected?() }, for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [restartBtn, quitBtn])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -110),
            
            statsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            
            stack.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 30),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.widthAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    private func createStyledButton(title: String, color: UIColor) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        btn.backgroundColor = color
        
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor(white: 1.0, alpha: 0.25).cgColor
        
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 3)
        btn.layer.shadowRadius = 4
        btn.layer.shadowOpacity = 0.4
        
        btn.heightAnchor.constraint(equalToConstant: 58).isActive = true
        return btn
    }
    
    func configureStats(runTime: TimeInterval, level: Int, damage: Int) {
        let minutes = Int(runTime) / 60
        let seconds = Int(runTime) % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        
        statsLabel.text = "SURVIVED: \(timeString)\nLEVEL REACHED: \(level)\nDAMAGE DEALT: \(damage)"
    }
}
