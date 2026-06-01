import SpriteKit

class HealthBarNode: SKNode {
    private var bgBar: SKSpriteNode!
    private var fillBar: SKSpriteNode!
    
    private let barWidth: CGFloat = 200.0
    private let barHeight: CGFloat = 20.0
    
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        bgBar = SKSpriteNode(color: .darkGray, size: CGSize(width: barWidth, height: barHeight))
        bgBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        fillBar = SKSpriteNode(color: .systemGreen, size: CGSize(width: barWidth, height: barHeight))
        fillBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        let borderRect = CGRect(x: 0, y: -barHeight/2, width: barWidth, height: barHeight)
        let border = SKShapeNode(rect: borderRect, cornerRadius: 4)
        border.strokeColor = .white
        border.lineWidth = 2
        
        addChild(bgBar)
        addChild(fillBar)
        addChild(border)
    }
    
    func updateHealth(current: Int, maxHealth: Int) {
        let percentage = CGFloat(current) / CGFloat(maxHealth)

        let ratio = min(1.0, max(0.0, percentage))
            
        let resizeAction = SKAction.resize(toWidth: barWidth * ratio, duration: 0.2)
        fillBar.run(resizeAction)
            
        if ratio > 0.6 {
            fillBar.color = .systemGreen
        } else if ratio > 0.3 {
            fillBar.color = .systemYellow
        } else {
            fillBar.color = .systemRed
        }
    }
}
