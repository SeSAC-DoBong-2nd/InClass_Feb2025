//
//  NotificationViewController.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/13/25.
//

import UIKit

import SnapKit

/*
 Notification 관련 정책
 - Foreground에서는 알림이 뜨지 않는 것이 default
 - Foreground에서 알림을 받고 싶은 경우, 별도 설정(delegate) 필요
 - trigger의 TimeInterval 기반 반복은 60초 이상부터 가능
 - 알림센터에 알림 스택 기준이 identifier. 각 알림의 고유값을 의미
 - 뱃지 숫자는 알림 개수와 무관. 일일이 관리 해주어야 함.
 - 알림센터에 보이고있는 지, 사용자에게 전달되었는지 알 수 없음
   - 10개를 요청했으나 10개 전부가 잘 갔는지 알 수 없다.
   - 단, 사용자가 알람을 '클릭' 했을 때에만 확인 가능(delegate)
    - ex) 10개 중 9개가 왔고 2개를 클릭하면 '클릭된게 2개있다.' 라고만 알 수 있다.
 - identifier: 고유값 / 64개 제한
   - 디데이 등과 관련된 어플 처럼 기존에 보낸 알람의 identifier는 앞으로 보낼 개수 제한인 64개에 포함되지 않음.
 */

final class NotificationViewController: UIViewController {
    
    private let requestButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        configureButton()
    }
    
    private func configureButton() {
        view.addSubview(requestButton)
        
        requestButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        requestButton.backgroundColor = .blue
        requestButton.addTarget(self, action: #selector(requestButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func requestButtonClicked() {
        print(#function)
        
        
        let content = UNMutableNotificationContent()
        content.title = "테스트 userinfo 활용"
        content.subtitle = "\(Int.random(in: 1...10000))"
        content.badge = 1
        
        //type과 같이 현재 알람이 광고 or 채팅 등 어떠한 타입의 알람인지 등을 UserInfo에 설정하여 이를 활용할 수 있음
        content.userInfo = ["type": 2, "id":4543]
        
        //트리거 종류: 1) 시간 간격, 2) 캘린더 기반 3) 위치 기반
        
        //시간 간격
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        //캘린더 기반
        //DateComponents가 구조체 이기에 var 변수로 선언하고 안의 속성 값을 바꿈
        var components = DateComponents()
        components.day = 14
        components.hour = 11 //오전 오후 둘 다 옴
        components.minute = 18
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        for i in 1...70 {
            let request = UNNotificationRequest(identifier: "jack: \(i)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                print("현재 error: \(error)")
            }
        }
        
        
    }
    
}

