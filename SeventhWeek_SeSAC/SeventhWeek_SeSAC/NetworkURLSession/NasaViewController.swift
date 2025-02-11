//
//  NasaViewController.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/11/25.
//

import UIKit

import Alamofire

enum Nasa: String, CaseIterable {
    static let baseURL = "https://apod.nasa.gov/apod/image/"
    
    case one = "2308/sombrero_spitzer_3000.jpg"
    case two = "2212/NGC1365-CDK24-CDK17.jpg"
    case three = "2307/M64Hubble.jpg"
    case four = "2306/BeyondEarth_Unknown_3000.jpg"
    case five = "2307/NGC6559_Block_1311.jpg"
    case six = "2304/OlympusMons_MarsExpress_6000.jpg"
    case seven = "2305/pia23122c-16.jpg"
    case eight = "2308/SunMonster_Wenz_960.jpg"
    case nine = "2307/AldrinVisor_Apollo11_4096.jpg"
    
    static var photo: URL {
        return URL(string: Nasa.baseURL + Nasa.allCases.randomElement()!.rawValue)!
    }
}

final class NasaViewController: UIViewController {
    
    private let requestButton = UIButton()
    private let progressLabel = UILabel()
    private let nasaImageView = UIImageView()
    
    //총 데이터의 양
    private var total: Double = 0
    //현재 받아온 데이터의 양
    private var buffer: Data? {
        didSet {
            let result = Double(buffer?.count ?? 0) / total
            progressLabel.text = "\(result * 100) / 100"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureHierarchy() {
        view.addSubview(requestButton)
        view.addSubview(progressLabel)
        view.addSubview(nasaImageView)
    }
    
    private func configureLayout() {
        requestButton.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(requestButton.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        nasaImageView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(progressLabel.snp.bottom).offset(20)
        }
        
    }
    
    private func configureView() {
        view.backgroundColor = .white
        requestButton.backgroundColor = .blue
        progressLabel.layer.borderWidth = 1
        progressLabel.layer.borderColor = UIColor.lightGray.cgColor
        progressLabel.backgroundColor = .white
        progressLabel.text = "100% 중 35.5% 완료"
        nasaImageView.backgroundColor = .systemBrown
        requestButton.addTarget(self, action: #selector(requestButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func requestButtonClicked() {
        print(#function)
        buffer = Data()
        callRequest()
    }
    
    private func callRequest() {
        //타임아웃
        //completionHandler: { data, response, error -> delegate }
        let request = URLRequest(url: Nasa.photo, timeoutInterval: 5)
        let configuration = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: .main
        )
        
        configuration.dataTask(with: request).resume()
    }
    
}

extension NasaViewController: URLSessionDataDelegate {
    
    // 서버에서 최초로 응답을 받은 경우에 호출
    // 상태코드
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        print("===1===", response)
        //상태코드가 성공일 때, contentLength
        if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
            
            //총 데이터의 양 얻기
            guard
                let contentLength = response.value(forHTTPHeaderField: "Content-Length")
            else { return .cancel }
            
            total = Double(contentLength) ?? 0
            
            return .allow
        } else {
            return .cancel
        }
    }
    
    // 서버에서 데이터를 받아올 때마다 반복적으로 호출
      // 현재 큰 용량을 다루기에 나눠서 받아오기 때문에 여러번 호출되는 것.
    // 실질적인 데이터!
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer?.append(data)
    }
    
    // 응답이 완료가 되었을 때 호출 (default가 아닌 shared에서 클로저를 사용할 때는 이 친구만 호출되는 느낌)
    // 응답을 끝까지 했을 때 에러 역시 없는지 판단.
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        print("===3===", error)
        if let error = error?.localizedDescription {
            print("error: \(error)")
            progressLabel.text = "error 발생"
        } else {
            //completionHandler 시점과 사실상 동일
            //buffer -> Data -> Image -> ImageView에 표시
            guard
                let buffer = buffer
            else {
                print("buffer 없음")
                return
            }
            let image = UIImage(data: buffer)
            nasaImageView.image = image
        }
    }
    
}


//


//response.expectedContentLength
