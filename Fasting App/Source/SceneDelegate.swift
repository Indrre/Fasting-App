//
//  SceneDelegate.swift
//  Fasting App
//
//  Created by indre zibolyte on 23/01/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let win = UIWindow(windowScene: windowScene)
            
            if (UserDefaults.standard.string(forKey: kAppleUserKey)?.isEmpty ?? true) {
                // User not present
                let controller = LoginViewController()
                
                win.rootViewController = UINavigationController(
                    rootViewController: controller
                )
            } else {
                // user is present
                UserService.refreshUser()
                let controller = MainViewController()
                
                win.rootViewController = UINavigationController(
                    rootViewController: controller
                )
                
            }
            window = win
            win.makeKeyAndVisible()
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
        
        if let mainController = UIApplication.shared.windows.first?.topViewController as? MainViewController {
            mainController.model.updateWater()
            mainController.model.updateWeight()

        }
        
       if let waterController = UIApplication.shared.windows.first?.topViewController as? WaterViewController {
            waterController.model.refresh()
       }
        
        if let weightController = UIApplication.shared.windows.first?.topViewController as? WeightViewContorller {
            weightController.model.refresh()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
