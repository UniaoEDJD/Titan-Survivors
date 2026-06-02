import SpriteKit

class XPBarNode: SKNode {
    private var bgBar: SKSpriteNode!
    private var fillBar: SKSpriteNode!
    
    private let barWidth: CGFloat = 200.0
    private let barHeight: CGFloat = 10.0
    
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
        
        fillBar = SKSpriteNode(color: .systemCyan, size: CGSize(width: barWidth, height: barHeight))
        fillBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        let borderRect = CGRect(x: 0, y: -barHeight/2, width: barWidth, height: barHeight)
        let border = SKShapeNode(rect: borderRect, cornerRadius: 2)
        border.strokeColor = .white
        border.lineWidth = 1.5
        
        addChild(bgBar)
        addChild(fillBar)
        addChild(border)
        
        fillBar.size.width = 0
    }
    
    func updateXP(current: Int, target: Int) {
        let safeTarget = max(1, target)
        let percentage = CGFloat(current) / CGFloat(safeTarget)
        let ratio = min(1.0, max(0.0, percentage))
        
        let resizeAction = SKAction.resize(toWidth: barWidth * ratio, duration: 0.1)
        fillBar.run(resizeAction)
    }
}
