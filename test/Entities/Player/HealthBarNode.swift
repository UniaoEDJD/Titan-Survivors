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
        // 1. Barra de Fundo (Cinza Escuro)
        bgBar = SKSpriteNode(color: .darkGray, size: CGSize(width: barWidth, height: barHeight))
        bgBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        // 2. Barra de Vida (Verde)
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
    
    // Função que será chamada sempre que o HP muda
    func updateHealth(current: Int, maxHealth: Int) {
        // 1. Calcular a percentagem pura
        let percentage = CGFloat(current) / CGFloat(maxHealth)

        // 2. TRAVA DE SEGURANÇA: O min(1.0, ...) garante que NUNCA passa de 100%
        // O max(0.0, ...) garante que NUNCA desce abaixo de 0%
        let ratio = min(1.0, max(0.0, percentage))
            
        // 3. Animar a barra (agora ela nunca vai passar do limite de barWidth!)
        let resizeAction = SKAction.resize(toWidth: barWidth * ratio, duration: 0.2)
        fillBar.run(resizeAction)
            
        // Mudar a cor dinamicamente com base no rácio seguro
        if ratio > 0.6 {
            fillBar.color = .systemGreen
        } else if ratio > 0.3 {
            fillBar.color = .systemYellow
        } else {
            fillBar.color = .systemRed
        }
    }
}
