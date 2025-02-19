//
//  DetailViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class DetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let nextButton = PointButton(title: "다음")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        navigationItem.title = "Detail"
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        //아래와 같이 작성했다 하더라도, tap 자체는 Observable<Int> 타입으로 만들어졌으나, 구독하는 횟수만큼 그 스트림이 각각 만들어진다.
            //그래서 tap 버튼이 눌려도 각 다른 값이 출력되는 것.
        //해결법: => share() 를 사용하여 제일 최신 값을 저장해두고 이후 구독하는 옵저버들에 그 최신 값을 뿌려준다.
        
        let tap = nextButton.rx.tap
            .map {Int.random(in: 1...100)}
            .share(replay: 1)
        
        tap
            .bind(with: self) { owner, value in
                print("1번 - \(value)")
            }
            .disposed(by: disposeBag)
        
        tap
            .bind(with: self) { owner, value in
                print("2번 - \(value)")
            }
            .disposed(by: disposeBag)
        
        tap
            .bind(with: self) { owner, value in
                print("3번 - \(value)")
            }
            .disposed(by: disposeBag)
    }
    
}
