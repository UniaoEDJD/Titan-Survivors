import SpriteKit

class VirtualJoystick: SKNode {
    private let baseNode: SKShapeNode
    private let knobNode: SKShapeNode
    private let maxRadius: CGFloat = 50.0
    
    var velocity: CGPoint = .zero
    
    override init() {
        baseNode = SKShapeNode(circleOfRadius: maxRadius)
        baseNode.fillColor = SKColor.gray.withAlphaComponent(0.5)
        baseNode.strokeColor = .clear
        
        knobNode = SKShapeNode(circleOfRadius: 25.0)
        knobNode.fillColor = SKColor.white
        knobNode.strokeColor = .clear
        
        super.init()
        
        addChild(baseNode)
        addChild(knobNode)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            moveKnob(to: touches.first?.location(in: self) ?? .zero)
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            moveKnob(to: touches.first?.location(in: self) ?? .zero)
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            resetKnob()
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            resetKnob()
        }
    
    private func moveKnob(to location: CGPoint) {
            let dx = location.x
            let dy = location.y
            let distance = sqrt(dx * dx + dy * dy)
            
            if distance <= maxRadius {
                knobNode.position = location
                velocity = CGPoint(x: dx / maxRadius, y: dy / maxRadius)
            } else {
                let angle = atan2(dy, dx)
                knobNode.position = CGPoint(x: cos(angle) * maxRadius, y: sin(angle) * maxRadius)
                velocity = CGPoint(x: cos(angle), y: sin(angle))
            }
        }
        
        private func resetKnob() {
            let moveBack = SKAction.move(to: .zero, duration: 0.1)
            moveBack.timingMode = .easeOut
            knobNode.run(moveBack)
            velocity = .zero
        }
}
