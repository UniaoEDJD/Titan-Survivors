# Titan Survivors: Project Plan

**Titan Survivors** is a 2D action-survival "bullet heaven" game inspired by the frantic mobility of *Attack on Titan* and the frictionless, addictive progression of *Vampire Survivors*.

Built natively for iOS using **Swift and SpriteKit**, this project is scoped strictly for an 8-week development cycle, focusing on high-performance rendering (60 FPS with 300+ entities) and polished, "game-feel" mechanics over complex sprawling systems.

## 🎯 Project Constraints & Scope

* **Engine:** Native iOS (Swift + SpriteKit).
* **Perspective:** 2D Top-Down / Isometric.
* **Input Paradigm:** Single-finger gameplay. The player dictates movement while attacks fire 100% automatically on cooldowns.
* **Flexible Play Sessions:** Scalable run lengths to respect player time:
  * *Quick Runs:* 1–3 minutes.
  * *Standard Survival:* 5–15 minutes.
  * *Endurance Mode:* 15–30 minutes.

## ⚙️ Core Systems

### 1. Gameplay Loop

* **Survive:** Navigate the 2D plane with fluid movement to dodge incoming hordes.
* **Slay:** Equipped ODM gear and weapons auto-fire based on cooldowns. No aiming required.
* **Scale:** Defeated enemies drop XP crystals. Collecting enough pauses the game, allowing the player to draft 1 of 3 randomized, permanent run-altering upgrades.

### 2. Progression System

* **In-Run Scaling:** Simple, refined stat boosts (e.g., +Speed, +Damage, +Pickup Radius, +Projectiles).
* **Meta-Progression:** Coins collected during runs can be spent in the main menu for permanent global stat increases.
* **Character Unlocks:** Distinct characters with different starting weapons and passive traits.

### 3. UI Screens

* **Title/Menu:** Clean start screen with Character Selection and Meta-Upgrades.
* **HUD:** Minimalist and non-intrusive. Top XP Bar, Run Timer, and Player HP.
* **Overlays:** Tactical pause for Level-Up drafting cards, and a Game Over summary screen (run stats & survival time).

## 🌍 World & Entities

### The Cast (Players)

* **The Recruit:** Balanced base stats. Starts with standard *Dual Blades* (close-range swipe).
* **The Vanguard:** +20% Move Speed, -20% Max HP. Starts with *ODM Hooks* (piercing projectiles).
* **The Veteran:** +10% Damage, +50% Magnet Radius. Starts with *Gas Canisters* (trailing AoE damage).

### The Horde (Enemies)

* **Pure Titans (Grunts):** High HP, slow movement. Walk in straight, predictable lines towards the player.
* **Abnormals (Swarmers):** Low HP, high speed. Use erratic, wave-like (sine-wave) movement paths to make dodging difficult.
* **Crawlers (Rushers):** Spawn at screen edges and dash rapidly in a straight line across the arena, forcing the player to reposition quickly.

### The Infinite Battlefield & Wave Director

The map is a seamless, infinite 2D plane. The camera remains locked to the player centrally while ground tiles reposition themselves seamlessly. The difficulty scales dynamically based on the run timer:

* **Min 0-5 (The Setup):** Slow trickle of Pure Titans. Allows player to safely pick their first build paths.
* **Min 5-10 (The Swarm):** Spawn rate doubles. Abnormals are introduced to force active dodging.
* **Min 10-14 (The Chaos):** Screen fills entirely. Crawlers dash through the horde. Gear synergies must be online to survive.
* **Min 14-15 (The Climax):** Massive density spawn. Pure survival check until the timer ends for victory.

## 💻 Technical Architecture (SpriteKit)

To achieve a massive entity count without dropping frames on mobile devices, strict architectural rules apply:

1. **Object Pooling (Mandatory):** Never use `removeFromParent()` or `addChild()` during active combat. Create arrays of inactive `SKSpriteNode` objects on launch. Recycle and reposition enemies/projectiles as they "die" or spawn.
2. **Kinematic Physics:** Do not use SpriteKit's dynamic physics solver for crowd movement. Set `isDynamic = false`. Use `contactTestBitMask` purely for collision detection (weapon hits enemy), but handle all movement logic manually in the `update()` loop via basic math.
3. **MVC Separation:** Decouple `GameScene` (pure rendering and input) from systems like `WeaponManager` and `WaveDirector` to keep the codebase clean and modular.

## 📅 8-Week Production Schedule

### Phase 1: Micro MVP Sprint (Weeks 1-2)

* **Goal:** Prove the engine can handle 300+ entities at 60 FPS.
* **Focus:** Build the core engine using only primitive geometric shapes (squares/circles). Implement player movement, the Infinite Map logic, and the critical Object Pooling system.

### Phase 2: Progression & Assets (Weeks 3-5)

* **Goal:** Establish the game loop and visual identity.
* **Focus:** Implement the UI Canvas, XP system, and the tactical pause level-up menu. Add the `WaveDirector` logic to control enemy spawns based on the timer. Replace placeholder shapes with actual SpriteKit 2D art textures.

### Phase 3: Arsenal & Polish (Weeks 6-8)

* **Goal:** Finalize content, game-feel, and stability.
* **Focus:** Introduce the remaining weapons (Thunder Spears, ODM Hooks) and the character roster. Add "juice" (floating damage numbers, screen shake, hit flashes). Add BGM and SFX. Final testing on a physical iOS device.

## 🚀 Future Ideas (Post-Release / Stretch Goals)

*These features are documented to preserve the long-term vision but are safely moved out of the initial 8-week scope to protect the development timeline.*

* **Devastating Ultimates:** A button-triggered "Titan Shift" for massive melee damage and invulnerability, or a rapid "Beyblade Dash" between enemies.
* **Synergistic Upgrades:** Combining max-level base weapons to create evolved, screen-clearing super weapons.
* **Complex AI Flocking:** Enemies that actively surround the player rather than just moving directly toward their coordinates.