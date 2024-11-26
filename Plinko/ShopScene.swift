import SwiftUI
import SpriteKit

struct ShopItem {
    var item: String
    var price: Int
    var bought: Bool
}

class ShopScene: SKScene {
    
    private var shopItems: [ShopItem] = [
        ShopItem(item: "moon", price: 150, bought: UserDefaults.standard.bool(forKey: "moon_bought")),
        ShopItem(item: "mars_ball", price: 150, bought: UserDefaults.standard.bool(forKey: "mars_ball_bought")),
        ShopItem(item: "earth_ball", price: 150, bought: UserDefaults.standard.bool(forKey: "earth_ball_bought")),
        ShopItem(item: "jupiter_ball", price: 150, bought: UserDefaults.standard.bool(forKey: "jupiter_ball_bought")),
        ShopItem(item: "saturn_ball", price: 150, bought: UserDefaults.standard.bool(forKey: "saturn_ball_bought")),
        ShopItem(item: "uran_ball", price: 150, bought: UserDefaults.standard.bool(forKey: "uran_ball_bought"))
    ]
    
    private var selectedBall: String = UserDefaults.standard.string(forKey: "selected_ball_name") ?? "whiteBall" {
        didSet {
            UserDefaults.standard.set(selectedBall, forKey: "selected_ball_name")
        }
    }
    
    private var userBalance = UserDefaults.standard.integer(forKey: "user_balance") {
        didSet {
            userBalanceLabel.text = "\(userBalance)"
            UserDefaults.standard.set(userBalance, forKey: "user_balance")
        }
    }
    private var userBalanceLabel: SKLabelNode!
    
    private var backBtn: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 750, height: 1350)
        
        let background = SKSpriteNode(imageNamed: "menuFon")
        background.size = CGSize(width: 1100, height: 2650)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background)
        
        backBtn = SKSpriteNode(imageNamed: "back")
        backBtn.position = CGPoint(x: 100, y: size.height - 130)
        backBtn.size = CGSize(width: 80, height: 80)
        addChild(backBtn)
        
        let shopTitle = SKSpriteNode(imageNamed: "shop_title")
        shopTitle.position = CGPoint(x: size.width / 2, y: size.height - 130)
        shopTitle.size = CGSize(width: 270, height: 80)
        addChild(shopTitle)
        
        let balanceBg = SKSpriteNode(imageNamed: "balance_bg")
        balanceBg.position = CGPoint(x: size.width / 2, y: size.height - 240)
        balanceBg.size = CGSize(width: 200, height: 80)
        addChild(balanceBg)
        
        userBalanceLabel = SKLabelNode(text: "\(userBalance)")
        userBalanceLabel.fontColor = .white
        userBalanceLabel.fontSize = 32
        userBalanceLabel.fontName = "WendyOne-Regular"
        userBalanceLabel.position = CGPoint(x: size.width / 2 + 20, y: size.height - 255)
        addChild(userBalanceLabel)
        
        var shopItemIndex: CGFloat = 0
        var shopItemYIndex: CGFloat = 0
        for (index, shopItem) in shopItems.enumerated() {
            createShopItemNode(shopItem: shopItem, pos: CGPoint(x: 230 + shopItemIndex * 300, y: size.height - 450 - (shopItemYIndex * 290)))
            shopItemIndex += 1
            if shopItemIndex == 2 {
                shopItemIndex = 0
            }
            if index > 0 {
                if (index + 1) % 2 == 0 {
                    shopItemYIndex += 1
                }
            }
        }
    }
    
    private func createShopItemNode(shopItem: ShopItem, pos: CGPoint) {
        let shopItemNode = SKSpriteNode()
        shopItemNode.position = pos
        
        let shopItemBg = SKSpriteNode(imageNamed: "shop_background")
        shopItemBg.size = CGSize(width: 270, height: 240)
        shopItemNode.addChild(shopItemBg)
        
        let ball = SKSpriteNode(imageNamed: shopItem.item)
        ball.size = CGSize(width: 140, height: 120)
        shopItemNode.addChild(ball)
        
        if shopItem.bought {
            let boughtBgNode = SKSpriteNode(imageNamed: "bought_bg")
            boughtBgNode.size = CGSize(width: 200, height: 60)
            boughtBgNode.position = CGPoint(x: 0, y: -120)
            boughtBgNode.name = "selectball_\(shopItem.item)"
            shopItemNode.addChild(boughtBgNode)
            
            var text = ""
            if selectedBall == shopItem.item {
                text = "SELECTED"
            } else {
                text = "SELECT"
            }
            let nodeText = SKLabelNode(text: "\(text)")
            nodeText.fontColor = .white
            nodeText.fontSize = 28
            nodeText.fontName = "WendyOne-Regular"
            nodeText.name = "selectball_\(shopItem.item)"
            nodeText.position = CGPoint(x: 0, y: -130)
            shopItemNode.addChild(nodeText)
        } else {
            let buyButton = SKSpriteNode(imageNamed: "buy_bg")
            buyButton.size = CGSize(width: 200, height: 60)
            buyButton.position = CGPoint(x: 0, y: -120)
            buyButton.name = "buyball_\(shopItem.item)"
            shopItemNode.addChild(buyButton)
        }
        
        addChild(shopItemNode)
    }
    
    private func restartScene() {
        let newScene = ShopScene()
        view?.presentScene(newScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            let nodes = nodes(at: loc)
            
            for node in nodes {
                if node.name?.contains("selectball") == true {
                    selectedBall = node.name!.components(separatedBy: "_")[1]
                    restartScene()
                }
                if node.name?.contains("buyball") == true {
                    purchasesBall(node.name!.components(separatedBy: "_")[1])
                }
                
                if node == backBtn {
                    if let view = self.view {
                        let menuScene = MenuScene(size: CGSize(width: 414, height: 896))
                        menuScene.scaleMode = .aspectFill
                        let transition = SKTransition.fade(withDuration: 1.0)
                        view.presentScene(menuScene, transition: transition)
                    }
                }
            }
        }
    }
    
    private func purchasesBall(_ name: String) {
        guard let shopItem = shopItems.filter({ $0.item == name }).first else { return }
        
        if userBalance >= shopItem.price {
            userBalance -= shopItem.price
            UserDefaults.standard.set(true, forKey: "\(name)_bought")
            restartScene()
        } else {
            showAlert(title: "Error!", message: "You don't have enought credits!")
        }
    }
    
    func showAlert(title: String, message: String) {
        // Получаем текущий view controller
        if let viewController = self.view?.window?.rootViewController {
            // Создаем UIAlertController
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            // Добавляем действие OK
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            
            // Показываем алерт
            viewController.present(alert, animated: true)
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: ShopScene())
            .ignoresSafeArea()
    }
}
