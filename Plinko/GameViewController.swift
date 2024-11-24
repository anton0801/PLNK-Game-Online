import UIKit
import SwiftUI
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingView()
        
    }
    
    private func showLoadingView() {
        let loadingView = UIHostingController(rootView: LoadingView())
        addChild(loadingView)
        loadingView.view.frame = view.bounds
        view.addSubview(loadingView.view)
        loadingView.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showMenu()
            loadingView.willMove(toParent: nil)
            loadingView.view.removeFromSuperview()
            loadingView.removeFromParent()
        }
    }
    
    private func showMenu() {
        if let view = self.view as? SKView {
                  if let menuScene = MenuScene(fileNamed: "Menu") {
                      menuScene.scaleMode = .aspectFill
                      view.presentScene(menuScene)
                  }
              } else {
                  let skView = SKView(frame: view.bounds)
                  self.view.addSubview(skView)
                  
                  if let menuScene = MenuScene(fileNamed: "Menu") {
                      menuScene.scaleMode = .aspectFill
                      skView.presentScene(menuScene)
                  }
              }
          }
    
    
    @objc private func showGameScene() {
        if let view = self.view as? SKView {
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        } else {
            let skView = SKView(frame: view.bounds)
            self.view.addSubview(skView)
            
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                skView.presentScene(scene)
            }
            
            skView.ignoresSiblingOrder = true
            skView.showsFPS = true
            skView.showsNodeCount = true
        }
    }
}

