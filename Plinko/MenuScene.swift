import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Загружаем сцену из файла Menu.sks
        guard let menuScene = SKScene(fileNamed: "Menu") else {
            return
        }
        
        for node in menuScene.children {
            node.removeFromParent()
            addChild(node)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Проверяем, что нажата кнопка "Play" или "Shop"
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "play" {
                if let view = self.view, let gameScene = GameScene(fileNamed: "GameScene") { // Загружаем GameScene из файла GameScene.sks
                    gameScene.scaleMode = .aspectFill
                    let transition = SKTransition.fade(withDuration: 1.0)
                    view.presentScene(gameScene, transition: transition)
                }
            } else if touchedNode.name == "shop" {
                
            } else if touchedNode.name == "exitBtn" {
                exit(0)
            }
        }
    }
}

