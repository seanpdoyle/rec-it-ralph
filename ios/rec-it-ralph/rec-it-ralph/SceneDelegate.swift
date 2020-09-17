import SwiftUI
import Turbolinks
import UIKit
import WebKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var applicationController = ApplicationViewController()
    lazy var turbolinksSession: Session = {
        let configuration = WKWebViewConfiguration()
        configuration.applicationNameForUserAgent = "RecItRalph iOS"
        
        return Session(webViewConfiguration: configuration)
    }()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            window.rootViewController = applicationController
            turbolinksSession.delegate = self
            visit(URL(string: "http://localhost:3000")!, animated: false)
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func visit(_ URL: URL, animated: Bool) {
        let visitable = VisitableViewController(url: URL)
        applicationController.pushViewController(visitable, animated: animated)
        
        turbolinksSession.visit(visitable)
    }
}

extension SceneDelegate: SessionDelegate {
    func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        // TODO
    }
    
    func session(_ session: Session, didProposeVisitToURL URL: URL, withAction action: Action) {
        switch action {
        case .Replace:
            visit(URL, animated: false)
        default:
            visit(URL, animated: true)
        }
    }
    
}
