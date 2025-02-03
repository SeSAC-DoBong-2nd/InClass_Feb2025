//
//  ViewController.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/3/25.
//

import UIKit

import CoreLocation
import MapKit
import SnapKit

final class ViewController: UIViewController {
    
    //1. 위치 매니저 생성: 위치에 관련된 대부분을 담당
    lazy var locationManager = CLLocationManager()
    
    let locationButton = UIButton()
    let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.getLotto2 { [weak self] lotto, error in
            //1. lotto, error 둘 중 하나는 무조건 nil인데 한번에 guard let을 진행하면 nil이 포함돼, 적용 안되고 else 로 빠짐
//            guard let self,
//                  let lotto,
//                  let error else { return }
            
            //2. 둘 중 하나는 무조건 nil 이기에 return으로 빠져나가니 활용할 수 없음.
//            guard let lotto = lotto else {
//                return
//            }
//            guard let error = error else {
//                return
//            }
        }
        
        NetworkManager.shared.getLotto3 { result in
            switch result {
            case .success(let success):
                //성공: lotto
                print()
            case .failure(let failure):
                //실패: alert
                print()
            }
        }   
        
        print(#function)
        view.backgroundColor = .white
        setDelegate()
//        checkDeviceLocation() lazy var로 인스턴스를 생성했기에 자동 실행.
        configureView()
    }
    
    private func setDelegate() {
        locationManager.delegate = self
    }
    
    private func configureView() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
        
        locationButton.backgroundColor = .red
        view.addSubview(locationButton)
        locationButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        locationButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
    }
    
    private func setRegionAndAnnotation(region: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: region, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    @objc
    func locationButtonClicked() {
        checkDeviceLocation()
    }
    
    //alert: 위치서비스 on,off 확인 -> 권한 허용 여부 alert
    private func checkDeviceLocation() {
        //현재 코드가 메인스레드에서 동작하고 있는지 확인
        print(Thread.isMainThread)
        DispatchQueue.global().async {
            print(Thread.isMainThread)
            //static 메서드이기 때문에 앞에 인스턴스 변수를 대동해여 사용할 수 없다.
            //iOS 시스템의 위치 서비스 활성화 여부 체크
            if CLLocationManager.locationServicesEnabled() {
                //현재 사용자 위치 권한 상태 확인
                //if 허용된 상태 > 권한 띄울 필요 X
                //if 거부한 상태 > 아이폰 설정 이동
                //if notDetermined > 권한 띄워주기
                print(self.locationManager.authorizationStatus.rawValue)
                
                DispatchQueue.main.async {
                    self.checkCurrentLocation()
                }
            } else {
                print("위치 서비스가 꺼져 있어서, 위치 권한 요청을 할 수 없습니다.")
            }
        }
    }
    
    //현재 사용자의 위치 권한 상태 확인
    private func checkCurrentLocation() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            print("이 상태에서만 권한 문구 띄울 수 있음")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //info.plist에 해당 설정과 동일한 값이 등록돼있어야함.
            locationManager.requestWhenInUseAuthorization()
            
//        case .restricted: //사용자 의지와 상관 없이 불가능한 상황
        case .denied:
            print("설정으로 이동하는 alert 띄우기")
        case .authorizedAlways:
            print("정상 로직 실행하면 됨 authorizedAlways")
        case .authorizedWhenInUse:
            print("정상 로직 실행하면 됨 authorizedWhenInUse")
            
            //현재 위치를 가져와 달라 (=GPS 기능을 써줘)
            locationManager.startUpdatingLocation()
//        case .authorized: //얘는 deplicated 됨, 쓸 일 없음
        default:
            print("오류 발생")
        }
        
    }

}

//2. 위치 프로토콜 선언
extension ViewController: CLLocationManagerDelegate {
    
    //+@ Hading: 나침반 (방향) 같은 걸 다룸
    //Locations: 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        print(locations)
        guard let region = locations.last?.coordinate
        else { return print("guard let region 에러") }
        print(region)
        setRegionAndAnnotation(region: region)
        
        //위에서 위도, 경도 데이터를 가져옴. 따라서 아래 동작들 가능
        //날씨 정보를 호출하는 API
        //지도를 현재위치 중심으로 이동시키는 기능
        
        //start를 했다면, 더이상 위치를 받아오지 않아도 되는 시점에 stop 메서드를 호출해야 한다.
        locationManager.stopUpdatingLocation()
    }
    
    //사용자의 취리를 성공적으로 가지고 오지 못한 경우
    //ex) 사용자가 위치 권한 거부 / 자녀 보호 기능 on, 위치서비스가 없는 등 위치서비스 관련 요청을 할 수 없는 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(#function)
    }
    
    //사용자의 권한상태가 변경될 때 or LocationManager 인스턴스가 생성되었을 때 (lazy var로 생성되면 생성되는 순간에 해당 함수 동작)
    //ex) 허용했었지만 사용자가 설정에서 '안함'으로 바꾸는 경우
    //iOS14 이상
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        //아이폰 위치 권한 상태가 변경되었으니 다시 확인.
        checkDeviceLocation()
    }
    
    //iOS14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
    }
    
}

extension ViewController: MKMapViewDelegate {
    
}
