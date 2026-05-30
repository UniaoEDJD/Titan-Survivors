import Foundation

struct PhysicsCategories{
    static let none: UInt32 = 0
    static let player: UInt32 = 0b1
    static let enemy: UInt32 = 0b10
    static let expGem: UInt32 = 0b100
    static let weapon: UInt32 = 0b1000
    static let powerUp: UInt32 = 0b10000
}
