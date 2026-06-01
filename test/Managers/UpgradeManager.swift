import Foundation

struct UpgradeOption{
    let id: String
    let title: String
    let description: String
    let rarity: UpgradeRarity
    let IconName: String
    
    let applyAffect: () -> Void
}

struct WeaponUpgradeState {
    var cooldownMult: Double = 1.0
    var extraShots: Int = 0
}

enum UpgradeRarity: String{
    case common = "Common"
    case rare = "Rare"
    case epic = "Epic"
    case divine = "Divine"
    
    var multiplier: Double {
        switch self{
        case .common: return 1.0
        case .rare: return 1.5
        case .epic: return 2.0
        case .divine: return 3.0
        }
    }
}

class UpgradeManager
{
 
    
    var playerSpeedMult: Double = 1.0
    var GlobalDamageMult: Double = 1.0
    var xpMultiplier: Double = 1.0
    var MagnetRadius: Double = 50.0
    var maxHealth: Int = 1000
    var healthMult: Double = 1.0
    var weaponStates: [String: WeaponUpgradeState] = [:]
    
    var effectiveMaxHealth: Int {
        return Int(Double(maxHealth) * healthMult)
    }
    
    private let statUpgradeIDs = ["flat_hp", "perc_hp", "spd_up", "dmg_up", "xp_up"]
    private let weaponUpgradeIDs = ["thunderspear_rate", "thunderspear_shots", "dualblades_rate", "dualblades_shots"]
    
    func rollUpgrades(count: Int = 3) -> [UpgradeOption]
    {
        var draftedUpgrades: [UpgradeOption] = []
        var pool: [String] = []
        
        for _ in 0..<10 { pool.append(contentsOf: statUpgradeIDs) }
        pool.append(contentsOf: weaponUpgradeIDs)
        
        var selectedIDs: [String] = []
        for id in pool.shuffled() {
            if !selectedIDs.contains(id) {
                selectedIDs.append(id)
                if selectedIDs.count == count { break }
            }
        }
        
        for id in selectedIDs {
            let rarity = rollRarity()
            let upgrade = generateUgrade(id: id, rarity: rarity)
            draftedUpgrades.append(upgrade)
        }
        
        return draftedUpgrades
    }
    
    private func rollRarity() -> UpgradeRarity {
        let roll = Int.random(in: 1...100)
        switch roll {
        case 1...5: return .divine
        case 6...20: return .epic
        case 21...50: return .rare
        default: return .common
        }
    }
    
    private func generateUgrade(id: String, rarity: UpgradeRarity) -> UpgradeOption {
        switch id {
        case "flat_hp":
            
            let baseAmount = Int.random(in: 10...20)
            let finalAmount = Int(Double(baseAmount) * rarity.multiplier)
            
            return UpgradeOption(id: id, title: "Cloak", description: "Increases hp by \(finalAmount)", rarity: rarity, IconName: "icon_hp")
            {
                self.maxHealth += finalAmount
            }
            
        case "perc_hp":
            let basePerc = Double.random(in: 0.04...0.08)
            let finalPerc = basePerc * rarity.multiplier
            let displayPerc = Int(finalPerc * 100)
            
            return UpgradeOption(id: id, title: "% HP", description: "Increase HP by \(displayPerc)%", rarity: rarity, IconName: "icon_hp")
            {
                self.healthMult += finalPerc
            }
            
        case "spd_up":
            let baseSpd = Double.random(in: 0.05...0.08)
            let finalSpd = baseSpd * rarity.multiplier
            let displaySpd = Int(finalSpd * 100)
            
            return UpgradeOption(id: id, title: "Boots", description: "Increases speed by \(displaySpd)%", rarity: rarity, IconName: "icon_spd")
            {
                self.playerSpeedMult += finalSpd
            }
        case "xp_up":
            let baseXP = Double.random(in: 0.10...0.25)
            let finalXP = baseXP * rarity.multiplier
            let displayXP = Int(finalXP * 100)
            
            return UpgradeOption(id: id, title: "Wisdom", description: "Increases XP gained by \(displayXP)%", rarity: rarity, IconName: "icon_mag")
            {
                self.xpMultiplier += finalXP
            }
        case "thunderspear_rate":
            let reduction = 0.08 * rarity.multiplier
            let displayPct = Int(reduction * 100)

            return UpgradeOption(id: id, title: "Spear Tempo", description: "Thunder spear cooldown -\(displayPct)%", rarity: rarity, IconName: "icon_dmg")
            {
                var state = self.weaponStates["thunderspear"] ?? WeaponUpgradeState()
                state.cooldownMult = max(0.2, state.cooldownMult - reduction)
                self.weaponStates["thunderspear"] = state
            }
        case "thunderspear_shots":
            let extra = max(1, Int(rarity.multiplier.rounded(.down)))

            return UpgradeOption(id: id, title: "Spear Volley", description: "Thunder spear fires +\(extra) spear(s)", rarity: rarity, IconName: "icon_dmg")
            {
                var state = self.weaponStates["thunderspear"] ?? WeaponUpgradeState()
                state.extraShots = min(3, state.extraShots + extra)
                self.weaponStates["thunderspear"] = state
            }
        case "dualblades_rate":
            let reduction = 0.10 * rarity.multiplier
            let displayPct = Int(reduction * 100)

            return UpgradeOption(id: id, title: "Blade Tempo", description: "Dual blades cooldown -\(displayPct)%", rarity: rarity, IconName: "icon_dmg")
            {
                var state = self.weaponStates["dualblades"] ?? WeaponUpgradeState()
                state.cooldownMult = max(0.2, state.cooldownMult - reduction)
                self.weaponStates["dualblades"] = state
            }
        case "dualblades_shots":
            let extra = max(1, Int(rarity.multiplier.rounded(.down)))

            return UpgradeOption(id: id, title: "Blade Chain", description: "Dual blades hits +\(extra) enemy/ies", rarity: rarity, IconName: "icon_dmg")
            {
                var state = self.weaponStates["dualblades"] ?? WeaponUpgradeState()
                state.extraShots = min(3, state.extraShots + extra)
                self.weaponStates["dualblades"] = state
            }
        default:
            let baseDmg = Double.random(in: 0.10...0.25)
            let finalDmg = baseDmg * rarity.multiplier
            let displayDmg = Int(finalDmg * 100)
            
            return UpgradeOption(id: id, title: "Reinforced Blades", description: "Increase damage by \(displayDmg)%", rarity: rarity, IconName: "icon_dmg")
            {
                self.GlobalDamageMult += finalDmg
            }
        }
        
        
    }

    func applyUpgrade(_ upgrade: UpgradeOption)
    {
        upgrade.applyAffect()
        print("applied upgrade: [\(upgrade.rarity.rawValue)] \(upgrade.title)")
    }
    
}
