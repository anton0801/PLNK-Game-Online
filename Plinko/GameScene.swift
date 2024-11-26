import SpriteKit
import SwiftUI
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var moon: SKSpriteNode?
    private var motionManager = CMMotionManager()
    private var blackHoles: [SKSpriteNode] = []
    private var whiteBall: SKSpriteNode?
    private var isBallDisappearing = false
    private var currentLevel: Int {
        get {
            return UserDefaults.standard.integer(forKey: "currentLevel")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentLevel")
        }
    }
    private var timerLabel: SKLabelNode!
    private var countdown = 120
    private var timer: Timer?
    
    private var tutorNode: SKSpriteNode? = nil

    struct PhysicsCategory {
        static let moon: UInt32 = 0x1 << 0
        static let blackBall: UInt32 = 0x1 << 1
        static let whiteBall: UInt32 = 0x1 << 2
        static let border: UInt32 = 0x1 << 3
    }

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = .zero

        moon = childNode(withName: "moon") as? SKSpriteNode
        moon?.physicsBody = SKPhysicsBody(circleOfRadius: (moon?.size.width ?? 0.0) / 2)
        moon?.physicsBody?.isDynamic = true
        moon?.physicsBody?.categoryBitMask = PhysicsCategory.moon

        enumerateChildNodes(withName: "blackBall") { node, _ in
            if let blackBall = node as? SKSpriteNode {
            self.blackHoles.insert(blackBall, at: 0)
            }
        }
        whiteBall = childNode(withName: "whiteBall") as? SKSpriteNode

        setupTimer()
        
        if !UserDefaults.standard.bool(forKey: "tutor_showed") {
            showTutor()
        } else {
            startGame()
        }
    }
    
    private func startGame() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
                guard let self = self, let data = data else { return }
                let dx = CGFloat(data.acceleration.x) * 10
                let dy = CGFloat(data.acceleration.y) * 4
                self.moon?.physicsBody?.applyForce(CGVector(dx: dx, dy: dy))
                self.checkCollisions()
            }
        }
    }
    
    private var currentTutorIndex = 0
    private var tutorRefs = [
        "tutor_1", "tutor_2", "tutor_3", "tutor_4", "tutor_5", "tutor_6"
    ]
    
    private func showTutor() {
        tutorNode = SKSpriteNode(imageNamed: tutorRefs[0])
        tutorNode!.size = size
        tutorNode!.zPosition = 100
        tutorNode!.position = CGPoint(x: 0, y: 0)
        tutorNode!.name = "tutor_node"
        addChild(tutorNode!)
    }

    private func checkCollisions() {
        guard let moon = moon, !isBallDisappearing else { return }

        for blackHole in blackHoles {
            if moon.intersects(blackHole ?? SKSpriteNode()) {
                moon.run(SKAction.fadeOut(withDuration: 0.3)) {
                    self.showLoseScene()
                }
            }
        }

        if moon.intersects(whiteBall ?? SKSpriteNode()) {
            moon.run(SKAction.fadeOut(withDuration: 0.3)) {
                self.showWinScene()
            }
        }
    }


    private func loadCurrentLevel() {
        let levelName = currentLevel == 1 ? "GameScene" : "Level\(currentLevel)"
        if let currentLevelScene = SKScene(fileNamed: levelName) {
            view?.presentScene(currentLevelScene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }

    private func loadNextLevel() {
        currentLevel += 1
        let levelName = "Level\(currentLevel)"
        if let nextLevelScene = SKScene(fileNamed: levelName) {
            view?.presentScene(nextLevelScene, transition: SKTransition.fade(withDuration: 1.0))
        } else {
            currentLevel = 1
            if let nextLevelScene = SKScene(fileNamed: "GameScene") {
                view?.presentScene(nextLevelScene, transition: SKTransition.fade(withDuration: 1.0))
            }
        }
    }

    private func setupTimer() {
        timerLabel = SKLabelNode(fontNamed: "WendyOne-Regular")
        timerLabel.fontSize = 24
        timerLabel.fontColor = .white
        timerLabel.position = CGPoint(x: size.width / 2, y: size.height - 50)
        addChild(timerLabel)

        updateTimerLabel()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.countdown -= 1
            self?.updateTimerLabel()

            if self?.countdown ?? 0 <= 0 {
                self?.loadCurrentLevel()
            }
        }
    }

    private func showLoseScene() {
        if let loseScene = SKScene(fileNamed: "Lose") {
            loseScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(loseScene, transition: transition)
        }
    }

    private func showWinScene() {
        if let winScene = SKScene(fileNamed: "Win") {
            winScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(winScene, transition: transition)
        }
    }

    private func updateTimerLabel() {
        timerLabel.text = "Time: \(countdown)s"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            let obj = atPoint(loc)
            
            if obj == tutorNode {
                if currentTutorIndex < tutorRefs.count - 1 {
                    currentTutorIndex += 1
                    tutorNode?.run(SKAction.setTexture(SKTexture(imageNamed: tutorRefs[currentTutorIndex])))
                } else {
                    tutorNode?.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()])) {
                        self.tutorNode = nil
                        UserDefaults.standard.set(true, forKey: "tutor_showed")
                        self.startGame()
                    }
                }
                return
            }
            
            if obj.name == "menuBtn" {
                if let view = self.view {
                    let menuScene = MenuScene(size: self.size)
                    menuScene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 1.0)
                    view.presentScene(menuScene, transition: transition)
                }
            }
        }
    }
}

#Preview {
    VStack {
        SpriteView(scene: GameScene())
            .ignoresSafeArea()
    }
}
