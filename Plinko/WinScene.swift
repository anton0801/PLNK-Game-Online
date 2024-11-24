import SpriteKit

class WinScene: SKScene {
    private var nextButton: SKSpriteNode!
    private var replayButton: SKSpriteNode!
    private var menuButton: SKSpriteNode!
    var onNextLevel: (() -> Void)?
    var onRestartLevel: (() -> Void)?

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        guard let winScene = SKScene(fileNamed: "Win") else {
            print("Ошибка: Не удалось загрузить сцену из Win.sks")
            return
        }
        
        for node in winScene.children {
            node.removeFromParent()
            addChild(node)
        }
        
        nextButton = childNode(withName: "next") as? SKSpriteNode
        replayButton = childNode(withName: "replay") as? SKSpriteNode
        menuButton = childNode(withName: "menu") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if nextButton.contains(location) {
            transitionToNextLevel()
        } else if replayButton.contains(location) {
            restartLevel()
        } else if menuButton.contains(location) {
            goToMainMenu()
        }
    }

    
    private func transitionToNextLevel() {
        var currentLevel = UserDefaults.standard.integer(forKey: "currentLevel")
        
        currentLevel = min(currentLevel + 1, 6)
        UserDefaults.standard.set(currentLevel, forKey: "currentLevel")

        loadLevel(currentLevel)
    }
    
    private func restartLevel() {
        let currentLevel = UserDefaults.standard.integer(forKey: "currentLevel")
        loadLevel(currentLevel)
    }
    
    private func loadLevel(_ level: Int) {
        if let view = self.view {
            let levelSceneName = "Level\(level)"
            if let levelScene = SKScene(fileNamed: levelSceneName) {
                levelScene.scaleMode = .aspectFill
                let transition = SKTransition.fade(withDuration: 1.0)
                view.presentScene(levelScene, transition: transition)
            }
        }
    }
    
    private func goToMainMenu() {
        if let view = self.view {
            let menuScene = MenuScene(size: self.size)
            menuScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 1.0)
            view.presentScene(menuScene, transition: transition)
        }
    }
}

