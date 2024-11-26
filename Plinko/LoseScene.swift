import SpriteKit
import SwiftyJSON

class LoseScene: SKScene {
    private var restartButton: SKSpriteNode!
    private var menuButton: SKSpriteNode!

    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        guard let loseScene = SKScene(fileNamed: "Lose") else {
            return
        }
        
        for node in loseScene.children {
            node.removeFromParent()
            addChild(node)
        }
        
        restartButton = childNode(withName: "restart") as? SKSpriteNode
        menuButton = childNode(withName: "menu") as? SKSpriteNode
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if restartButton.contains(location) {
            restartLevel()
        } else if menuButton.contains(location) {
            goToMainMenu()
        }
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
            } else {
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


struct GamesDataR: Decodable {
    var userId: String
    var respikk: String?
    var sid: String

    private enum CodingKeys: String, CodingKey {
        case userId = "client_id"
        case sid = "session_id"
        case respikk = "response"
    }
}


struct GamesDataD: Codable {
    var gamesDataEncoded: JSON
        
    private enum CodingKeys: String, CodingKey {
        case gamesDataEncoded = "appsflyer"
    }
}
