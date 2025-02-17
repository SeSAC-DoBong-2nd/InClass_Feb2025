//
//  AppDelegate.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/3/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Notification 1. 알림 권한 설정
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            print(success, error)
        }
        
        //Notification 2. 포그라운드 수신을 위한 Delegate 설정
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //Notification 2. 포그라운드 수신
    //ex. 친구랑 1:1 채팅하고있는 경우, 상대방의 푸시는 안 와야함. 다른 단톡방/갠톡방 등만 푸시가 오는 것처럼, 특정 화면 or 조건에 대해서 포그라운드 알람을 받는 것이 가능
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //banner + list = alert
        completionHandler([.banner, .badge, .list, .sound])
    }
    
    //알람을 사용자가 클릭했는지 알 수 있는 메서드
    //활용 예시) - 딸기 상품 페이지로 이동, 혹은 카카오톡 채팅방 이동
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
        
        //response.notification.request
        // = 알람을 요청할 때 썼던 request 정보들이 모여있음
        print(response.notification.request.identifier)
        print(response.notification.request.content.title)
        print(response.notification.request.content.subtitle)
        
        print(response.notification.request.content.userInfo)
        print(response.notification.request.content.userInfo["type"] as? Int)
        print(response.notification.request.content.userInfo["type"])
    }
    
}
