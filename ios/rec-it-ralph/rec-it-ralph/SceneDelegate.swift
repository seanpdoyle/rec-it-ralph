import SwiftUI
import Turbolinks
import UIKit
import WebKit

class ScriptMessageHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // ...
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var contentView = ContentView()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let bridgeController = BridgeController()

            let configuration = WKWebViewConfiguration()
            let scriptMessageHandler = bridgeController
            configuration.applicationNameForUserAgent = "RecItRalph iOS"
            configuration.userContentController.add(scriptMessageHandler, name: "application")
            
            let turbolinksSession = Session(webViewConfiguration: configuration)
            bridgeController.turbolinksSession = turbolinksSession
            turbolinksSession.delegate = bridgeController
            
            let contentView = ContentView().environmentObject(bridgeController)
            window.rootViewController = UIHostingController(rootView: contentView)
        
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

