//
//  SceneDelegate.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/3/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        
        self.window?.rootViewController = UINavigationController(rootViewController: NotificationViewController())
        
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
        //#Badge 제거
//        UIApplication.shared.applicationIconBadgeNumber = 0 //deprecated 됨
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            print("현재 error: \(error)")
        }
        
//        //사용자에게 전달되어 있는 알람 제거 (default 값은 알람을 클릭해서 열어줘야 해당 알람만 제거됨!)
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        
//        //사용자에게 아직 전달되지 않았지만, 앞으로 전달될 알람을 제가
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
        
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


}

