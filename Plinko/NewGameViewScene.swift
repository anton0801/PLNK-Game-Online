import SwiftUI
import WebKit

struct NewGameViewScene: View {
    
    @State var navigationVisible = false
    private var publisherForHide = NotificationCenter.default.publisher(for: .hideNavigation)
    
    var body: some View {
        VStack {
            NextLevelOfGameView(gameNextLevel: URL(string: UserDefaults.standard.string(forKey: "resp") ?? "")!)
            if navigationVisible {
                ZStack {
                    Color.black
                    HStack {
                        Button {
                            func sendNotifToCenterBy(name: Notification.Name) {
                                NotificationCenter.default.post(name: name, object: nil)
                            }
                            sendNotifToCenterBy(name: .backerbacker)
                        } label: {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        
                        Button {
                            func sendNotifToCenterBy(name: Notification.Name) {
                                NotificationCenter.default.post(name: name, object: nil)
                            }
                            sendNotifToCenterBy(name: .pokerrloadgame)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    .padding(5)
                }
                .frame(height: 61)
            }
            
        }
        .edgesIgnoringSafeArea([.trailing,.leading])
        .preferredColorScheme(.dark)
        .onReceive(publisherForHide, perform: { _ in
            withAnimation(.linear(duration: 0.4)) { navigationVisible = false }
        })
        .onReceive(publisherForShow, perform: { _ in
            withAnimation(.linear(duration: 0.4)) { navigationVisible = true }
        })
    }
    
    private var publisherForShow = NotificationCenter.default.publisher(for: .showNavigation)
    
}

#Preview {
    NewGameViewScene()
}

extension Notification.Name {
    static let bdashjbdsajbdjaskndasd = Notification.Name("ndsjandads")
    static let hideNavigation = Notification.Name("hide_navigation")
    static let dsabjhdbsad = Notification.Name("ndjsandbsajkd")
    static let showNavigation = Notification.Name("show_navigation")
    static let dsandjasnd = Notification.Name("bdhsjadbasd")
    static let backerbacker = Notification.Name("backerbacker")
    static let bdsajhbdad = Notification.Name("ndjsakndksjand")
    static let pokerrloadgame = Notification.Name("pokerrloadgame")
    static let bdjhasbdasbdjsabda = Notification.Name("ndsjakdnsand")
}

struct NextLevelOfGameView: UIViewRepresentable {
    
    let gameNextLevel: URL
    
    @State var nextLevelOfTheGamePrimaryView: WKWebView = WKWebView()
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: gameNextLevel))
    }
    
    @State var gameWindows: [WKWebView] = []
    
    func makeUIView(context: Context) -> WKWebView {
        let conf = WKWebViewConfiguration()
        let newprefs = WKWebpagePreferences()
        let oldprefs = WKPreferences()
        conf.allowsInlineMediaPlayback = true
        newprefs.allowsContentJavaScript = true
        conf.defaultWebpagePreferences = newprefs
        oldprefs.javaScriptCanOpenWindowsAutomatically = true
        conf.preferences = oldprefs
        conf.requiresUserActionForMediaPlayback = false
        nextLevelOfTheGamePrimaryView = WKWebView(frame: .zero, configuration: conf)
        nextLevelOfTheGamePrimaryView.uiDelegate = context.coordinator
        nextLevelOfTheGamePrimaryView.navigationDelegate = context.coordinator
        nextLevelOfTheGamePrimaryView.allowsBackForwardNavigationGestures = true
        getLevelMap()
        return nextLevelOfTheGamePrimaryView
    }
    
    func makeCoordinator() -> NextLevelGameCoordinator {
        NextLevelGameCoordinator(parent: self)
    }
    
}


extension NextLevelOfGameView {
    
    func restartGameWithClearProgress() {
        gameWindows.forEach { $0.removeFromSuperview() }
        gameWindows.removeAll()
        nextLevelOfTheGamePrimaryView.load(URLRequest(url: gameNextLevel))
        NotificationCenter.default.post(name: .hideNavigation, object: nil)
    }
    
    func getLevelMap() {
        
        func getDataLevelMap() -> [String: [String: [HTTPCookiePropertyKey: AnyObject]]]? {
            return UserDefaults.standard.dictionary(forKey: "game_saved_data") as? [String: [String: [HTTPCookiePropertyKey: AnyObject]]]
        }
        
        if let allLevelData = getDataLevelMap() {
            allLevelData.forEach { (_, levelDataList) in
            }
            for (_, levelDataList) in allLevelData {
                for (_, levelData) in levelDataList {
                    let levelItem = levelData as? [HTTPCookiePropertyKey: AnyObject]
                    if let levelMapitems = levelItem,
                       let levelItemToPresent = HTTPCookie(properties: levelMapitems) {
                        func ndsjadnkjsadas() {
                            nextLevelOfTheGamePrimaryView.configuration.websiteDataStore.httpCookieStore.setCookie(levelItemToPresent)
                        }
                        ndsjadnkjsadas()
                    }
                }
            }
        }
    }
    
    func backGame() {
        if !gameWindows.isEmpty {
            restartGameWithClearProgress()
        } else if nextLevelOfTheGamePrimaryView.canGoBack {
            nextLevelOfTheGamePrimaryView.goBack()
        }
    }
    
    func restartGame() {
        nextLevelOfTheGamePrimaryView.reload()
    }
    
}

class NextLevelGameCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
    
    var viewParent: NextLevelOfGameView
    
    @objc private func ndsajkdnsad() {
        viewParent.backGame()
    }
    
    init(parent: NextLevelOfGameView) {
        self.viewParent = parent
    }
    
    private func dnsajkdnaskjfnsad(levelData: [String: [String: HTTPCookie]]) -> [String: [String: AnyObject]] {
        var allLevelData = [String: [String: AnyObject]]()

        for (keysleveldataname, levelDataValue) in levelData {
            var levelDataCompresed = [String: AnyObject]()
            for (fnasjdkad, ndfsjkda) in levelDataValue {
                levelDataCompresed[fnasjdkad] = ndfsjkda.properties as AnyObject
            }
            allLevelData[keysleveldataname] = levelDataCompresed
        }
        return allLevelData
    }
    
    private func convertLevelData(_ allNotObrabotanaya: [HTTPCookie]) -> [String: [String: HTTPCookie]] {
        var levelDataPredObrabResult = [String: [String: HTTPCookie]]()
        for levelDataToConvert in allNotObrabotanaya {
            var levelDataItems = levelDataPredObrabResult[levelDataToConvert.domain] ?? [:]
            levelDataItems[levelDataToConvert.name] = levelDataToConvert
            levelDataPredObrabResult[levelDataToConvert.domain] = levelDataItems
        }
        return levelDataPredObrabResult
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { nfsjakdnksajd in
            UserDefaults.standard.set(self.dnsajkdnaskjfnsad(levelData: self.convertLevelData(nfsjakdnksajd)), forKey: "game_saved_data")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NotificationCenter.default.addObserver(self, selector: #selector(dsadssdsad), name: .pokerrloadgame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ndsajkdnsad), name: .backerbacker, object: nil)
    }
    
    
    
    private func configureForShowNewWindowForGame(_ windableView: WKWebView) {
        windableView.scrollView.isScrollEnabled = true
        windableView.allowsBackForwardNavigationGestures = true
        windableView.translatesAutoresizingMaskIntoConstraints = false
        windableView.uiDelegate = self
        windableView.navigationDelegate = self
        NSLayoutConstraint.activate([
            windableView.topAnchor.constraint(equalTo: viewParent.nextLevelOfTheGamePrimaryView.topAnchor),
            windableView.bottomAnchor.constraint(equalTo: viewParent.nextLevelOfTheGamePrimaryView.bottomAnchor),
            windableView.leadingAnchor.constraint(equalTo: viewParent.nextLevelOfTheGamePrimaryView.leadingAnchor),
            windableView.trailingAnchor.constraint(equalTo: viewParent.nextLevelOfTheGamePrimaryView.trailingAnchor)
        ])
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil {
            let levelGameNewLevel = WKWebView(frame: .zero, configuration: configuration)
            viewParent.nextLevelOfTheGamePrimaryView.addSubview(levelGameNewLevel)
            configureForShowNewWindowForGame(levelGameNewLevel)
            NotificationCenter.default.post(name: .showNavigation, object: nil)
            if navigationAction.request.url?.absoluteString == "about:blank" || navigationAction.request.url?.absoluteString.isEmpty == true {
                
                
            } else {
                levelGameNewLevel.load(navigationAction.request)
            }
            viewParent.gameWindows.append(levelGameNewLevel)
            return levelGameNewLevel
        }
        NotificationCenter.default.post(name: .hideNavigation, object: nil, userInfo: nil)
        return nil
    }
    
    @objc private func dsadssdsad() {
        viewParent.restartGame()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let dnsajkfdnasd = navigationAction.request.url, ["newapp://", "tg://", "viber://", "whatsapp://"].contains(where: dnsajkfdnasd.absoluteString.hasPrefix) {
            func deepedOpen() {
                UIApplication.shared.open(dnsajkfdnasd, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
            }
            deepedOpen()
        } else {
            decisionHandler(.allow)
        }
    }
      
}
