//
//  SceneDelegate.swift
//  MBTA
//
//  Created by Abhinav Verma on 16/02/20.
//  Copyright © 2020 Abhinav Verma. All rights reserved.
//

import UIKit
import SideMenuSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    static let hud = MBProgressHUD()
    
    private(set) static var shared: SceneDelegate?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor = #colorLiteral(red: 0.2941176471, green: 0.01568627451, blue: 0.01568627451, alpha: 1)
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        SceneDelegate.shared = self
        window = UIWindow(windowScene: windowScene)
        self.updateRoot()
        return
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func updateRoot () {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard UserDefaults.standard.bool(forKey: "isAuthenticated") else {
            
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
            let navigation = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigation
            window?.makeKeyAndVisible()
            return
        }
        
        let viewController = mainStoryboard.instantiateInitialViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
    }


}

extension SceneDelegate {
    
        func showHUD() {
            DispatchQueue.main.async {
                if let window = self.window {
                    window.addSubview(SceneDelegate.hud)
                    SceneDelegate.hud.show(animated: true)
                }
            }
        }
        
        func hideHUD() {
            DispatchQueue.main.async {
                SceneDelegate.hud.hide(animated: true)
                SceneDelegate.hud.removeFromSuperview()
            }
        }
}
