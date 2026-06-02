import UIKit

class GameVictoryView: UIView {
    
    var onReturnToMenuSelected: (() -> Void)?
    
    private let bgBlurredImage = UIImageView(image: UIImage(named: "victory"))
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private let bgMainImage = UIImageView(image: UIImage(named: "victory"))
    
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
        bgBlurredImage.frame = self.bounds
        blurView.frame = self.bounds
        bgMainImage.frame = self.bounds
    }
    
    private func setupUI() {
        self.backgroundColor = .black
        
        bgBlurredImage.contentMode = .scaleAspectFill
        bgBlurredImage.clipsToBounds = true
        addSubview(bgBlurredImage)
        
        addSubview(blurView)
        
        bgMainImage.contentMode = .scaleAspectFit
        addSubview(bgMainImage)
        
        let titleLabel = UILabel()
        titleLabel.text = "SHINZOU WO SASAGEYO!"
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 44)
        titleLabel.textColor = UIColor(red: 0.98, green: 0.82, blue: 0.20, alpha: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowRadius = 8.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = "For the first time... humanity has won against the Titans."
        subTitleLabel.font = UIFont(name: "AvenirNext-MediumItalic", size: 18)
        subTitleLabel.textColor = .white
        subTitleLabel.textAlignment = .center
        subTitleLabel.layer.shadowColor = UIColor.black.cgColor
        subTitleLabel.layer.shadowRadius = 4.0
        subTitleLabel.layer.shadowOpacity = 0.8
        subTitleLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subTitleLabel)
        
        statsLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        statsLabel.textColor = UIColor(red: 0.75, green: 0.95, blue: 0.75, alpha: 1.0)
        statsLabel.textAlignment = .left
        statsLabel.numberOfLines = 3
        statsLabel.layer.shadowColor = UIColor.black.cgColor
        statsLabel.layer.shadowRadius = 4.0
        statsLabel.layer.shadowOpacity = 0.9
        statsLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statsLabel)
        
        let arrowBtn = UIButton(type: .system)
        arrowBtn.tintColor = .white
        arrowBtn.backgroundColor = UIColor(red: 0.12, green: 0.30, blue: 0.18, alpha: 0.95) // Scout Green
        
        let arrowConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        let arrowIcon = UIImage(systemName: "arrow.right", withConfiguration: arrowConfig)
        arrowBtn.setImage(arrowIcon, for: .normal)
        
        arrowBtn.layer.cornerRadius = 28
        arrowBtn.layer.borderWidth = 1.5
        arrowBtn.layer.borderColor = UIColor(white: 1.0, alpha: 0.35).cgColor
        
        arrowBtn.layer.shadowColor = UIColor.black.cgColor
        arrowBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        arrowBtn.layer.shadowRadius = 4
        arrowBtn.layer.shadowOpacity = 0.4
        
        arrowBtn.translatesAutoresizingMaskIntoConstraints = false
        arrowBtn.addAction(UIAction { [weak self] _ in self?.onReturnToMenuSelected?() }, for: .touchUpInside)
        addSubview(arrowBtn)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -110),
            
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            statsLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5),
            statsLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 40),
            
            arrowBtn.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            arrowBtn.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            arrowBtn.widthAnchor.constraint(equalToConstant: 56),
            arrowBtn.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    func configureStats(level: Int, damage: Int) {
        statsLabel.text = "🏆 SURVIVED: 15:00 \n⭐ LEVEL REACHED: \(level)\n⚔️ TOTAL DAMAGE: \(damage)"
    }
}
