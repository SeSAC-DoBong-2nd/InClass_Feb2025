//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
    
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    //랜덤 배열
    let recommandList = ["123", "455", "464", "574", "461"]
    
    //Observable.just("고래밥") : 얘는 옵저버블이기에 이벤트를 받아 처리할 수 없다. 따라서 subject 사용
        //이제 = 등호 사용한 값 전달 하지 않음.
    
    let nickname = PublishSubject<String>()
    //BehaviorSubject(value: "고래밥")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
        testPublishSubject()
    }
    
    func testBehaviorSubject() {
        //이벤트 전달 및 처리 둘 다 가능 한 놈 = subject
        let subject = BehaviorSubject(value: 1)
        //BehaviorSubject
            //초깃값을 무조건 가지고있어야함
            //subscribe 이전에는 쓰이지 않는데, 초깃값을 갖고있는 프로파티타입이기에,
            //구독 이전에 emit한 이벤트가 있다면 가장 최근에 전달된 이벤트 하나를 받을 수 있다.
            //구독 이전에 emit한 이벤트가 없다면 초깃값을 전달한다.
            //뷰를 미리 채워두기 용이함
            // 따라서 아래 예시에서는 subscribe 이전 가장 최신값인 5가 초깃값으로 들어감.
        
        subject.onNext(2)
        subject.onNext(5)
        
        subject
            .subscribe(with: self) { owner, value in
                print(#function, value)
            } onError: { owner, error in
                print("BehaviorSubject onError: \(error)")
            } onCompleted: { owner in
                print("BehaviorSubject onCompleted")
            } onDisposed: { owner in
                print("BehaviorSubject Disposed")
            }.disposed(by: disposeBag)
        
        subject.onNext(7)
        subject.onNext(9)
        subject.onNext(16)
        
        subject.onCompleted()
        subject.onNext(45)
        subject.onNext(75)
    }
    
    func testPublishSubject() {
        //이벤트 전달 및 처리 둘 다 가능 한 놈 = subject
        let subject = PublishSubject<Int>()
        //PublishSubject
            //얘는 BehaviorSubject의 초깃값 없는 버전.
        
        subject.onNext(2)
        subject.onNext(5)
        
        subject
            .subscribe(with: self) { owner, value in
                print(#function, value)
            } onError: { owner, error in
                print("PublishSubject onError: \(error)")
            } onCompleted: { owner in
                print("PublishSubject onCompleted")
            } onDisposed: { owner in
                print("PublishSubject Disposed")
            }.disposed(by: disposeBag)
        
        subject.onNext(7)
        subject.onNext(9)
        subject.onNext(16)
        
        subject.onCompleted()
        subject.onNext(45)
        subject.onNext(75)
    }
    
    func bind() {
        //1) complete X
        //2) event 받을 수 있는 상태
        nickname.subscribe(with: self) { owner, value in
            owner.nicknameTextField.text = value
        } onError: { owner, error in
            print("nickname onError: \(error)")
        } onCompleted: { owner in
            print("nickname onCompleted")
        } onDisposed: { owner in
            print("nickname Disposed")
        }.disposed(by: disposeBag)
        
        //map: 함수 매개변수 안에 함수가 있는 상태
        // map({}) == map { } => @autoclosure 생략해주는 기능
        
        nickname.onNext("테스트 케케몬1")
        nickname.onNext("테스트 케케몬2")
        nickname.onNext("테스트 케케몬3")
        nextButton.rx
            .tap //여기 까지는 아래 value가 void 였는데,
            .map { //map을 거치고 나니 string이 됨.
                let random = self.recommandList.randomElement()!
                return random
            }
            .subscribe(with: self) { owner, value in
                
                print("nextButton next")
                //nickname
                owner.nickname.onNext(value)
                
            } onError: { owner, error in
                print("nextButton onError: \(error)")
            } onCompleted: { owner in
                print("nextButton onCompleted")
            } onDisposed: { owner in
                print("nextButton Disposed")
            }
            .disposed(by: disposeBag)
        
        
        //withUnretained: 약한 참조를 통해 self 캡쳐 현상 방지.
        //Observable 체인 구독 과정
        //아래에서 위로 구독을 전파하게 된다. (다운스트림에서 업스트림)
        //맨 마지막 연산자에서 이전 연산자를 구독하는 형태로 위로 올라가는 방식
//        nextButton.rx
//            .tap //여기 까지는 아래 value가 void 였는데,
//            .debug("-jack 1-")
//            .withUnretained(self) //map 안의 self 순환참조를 해결할 owner를 사용할 수 있게 됨.
//            .debug("-jack 2-")
//            .map { owner, _ in //map을 거치고 나니 string이 됨.
//                let random = owner.recommandList.randomElement()!
//                return random
//            }
//            .debug("-jack 3-")
//            .bind(to: nickname)
//            .disposed(by: disposeBag)
        
        
        //tap이라는 void를 string으로 바꿔주는 두번째 방법
          //map을 써도 되지만, 옵저버블 2개를 결합하여 해결할 수도 있음.
//        nextButton.rx.tap
//            .withLatestFrom(Observable.just(recommandList.randomElement()!))
//            .flatMapLatest({ [weak self] in
//                Observable.just(self?.recommandList.randomElement()! ?? "")
//            })
//            .bind(to: nickname)
//            .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        //        navigationController?.pushViewController(BirthdayViewController(), animated: true)
    }
    
    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}
