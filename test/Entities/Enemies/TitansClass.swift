import Foundation
import SpriteKit

class NormalTitan: EnemyNode {
    init() {
        super.init(texture: nil, color: .systemGreen, size: CGSize(width: 30, height: 30))
        self.name = "normalTitan"
        self.maxHealth = 1000.0
        self.movementSpeed = 2.0
        self.damage = 10.0
        self.xpReward = 1
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AbnormalTitan: EnemyNode {
    init() {
        super.init(texture: nil, color: .systemPurple, size: CGSize(width: 40, height: 40))
        self.name = "abnormalTitan"
        self.maxHealth = 2500.0
        self.movementSpeed = 3.5
        self.damage = 25.0
        self.xpReward = 5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CrawlerTitan: EnemyNode {
    init() {
        super.init(texture: nil, color: .systemRed, size: CGSize(width: 20, height: 20))
        self.name = "crawlerTitan"
        self.maxHealth = 400.0
        self.movementSpeed = 5.5
        self.damage = 5.0
        self.xpReward = 2
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
