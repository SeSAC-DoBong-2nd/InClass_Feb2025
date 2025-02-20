//
//  ViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

enum JackError: Error {
    case incorrent
}

final class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    private let nextButton = PointButton(title: "다음")
    
    private let textFieldText = BehaviorRelay(value: "케케몬 \(Int.random(in: 1...100))")
    private let quiz = Int.random(in: 1...10)
    
    //PublishSubject로 하면 build 시 바로 시작되는 일 없음
        //왜? 초깃값이 없기 때문
//    private let textFieldText = PublishSubject<String>()
    
    private let publishSubject = PublishSubject<Int>()
    private let behaviorSubject = BehaviorSubject(value: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
//        button()
//        bindButton()
//        bindTextField()
//        bindTextFieldOfSubject()
        print("quiz: \(quiz)")
        
        bindCustomObservable()
        randomNumber()
            .bind(with: self) { owner, value in
                print("randomNumber",value)
            }.disposed(by: disposeBag)
    }
    
    //이는 Observable.just 와 같이 쓸 수 있는 친구들을 Observable을 반환하는 함수를 만들어 대체한 것
    // = 커스텀 한 것
    func randomNumber() -> Observable<Int> {
        return Observable<Int>.create { value in
            value.onNext(Int.random(in: 1...10))
            return Disposables.create()
        }
    }
    
    // * 커스텀오퍼레이터 만들기
    
    func randomQuiz(number: Int) -> Observable<Bool> {
        
        return Observable<Bool>.create { value in
            
            if number == self.quiz {
                value.onNext(true)
            } else {
                value.onNext(false)
            }
            value.onCompleted() //이를 아래 .single()로도 대체 가능하다. 왜냐하면 .single() 안에 해당 코드가 내포됨.
            return Disposables.create()
        }
    }
    
    func play(value: Int) {
        randomQuiz(number: value)
            .single()
            .subscribe(with: self) { owner, bool in
                print("next \(bool)")
            } onError: { owner, error in
                print("onError \(error)")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }.disposed(by: self.disposeBag)
    }
    
    func bindCustomObservable() {
        nextButton.rx.tap
            .map { Int.random(in: 1...10) }
            .bind(with: self) { owner, value in
                print("value: \(value)")
                
                owner.play(value: value)
            }.disposed(by: disposeBag)
    }
    
    /*
     특정 기능으로 인하여 textField.text를 바꾸어야 한다면, orEmpty로는 그렇게 바뀌는 걸 추적할 수 없으니 아래 bindTextFieldOfSubject와 같이 진행한다.
     */
    func bindTextFieldOfSubject() {
        textFieldText
            .subscribe(with: self) { owner, value in
                print("textFieldText subscribe: \(value)")
                owner.nicknameTextField.text = value
                print("111111111")
            }.disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(with: self) { owner, _ in
                //BehaviorSubject의 value 가져오기
//                print("BehaviorSubject의 value 가져오기")
                    //아래와 같이 초깃값을 곧바로 활용할 수 있으니, BehaviorSubject를 사용할 때에 lazy var를 사용하지 않아도 좋다.
//                do {
//                    let result = try owner.textFieldText.value()
//                    owner.textFieldText.onNext(result)
//                } catch {
//                    print("케케 error 발생")
//                }
                
                //BehaviorRelay의 value 가져오기
                print("BehaviorRelay의 value 가져오기")
                //사실 relay를 써도 value 안에 subject가 한번 랩핑돼서 나온 거기에 아래와 같이 축약된 것이다.
                let result = owner.textFieldText.value
                print(result)
                owner.textFieldText.accept(result)
            }.disposed(by: disposeBag)
        
//        nicknameTextField.rx.text.orEmpty
//            .subscribe(with: self) { owner, value in
//                print("nicknameTextField subscribe: \(value)")
//                owner.textFieldText.onNext(value)
//            } onError: { owner, error in
//                print(#function, "nicknameTextField onError")
//            } onCompleted: { owner in
//                print(#function, "nicknameTextField onCompleted")
//            } onDisposed: { owner in
//                print(#function, "nicknameTextField onDisposed")
//            }.disposed(by: disposeBag)
    }
    
    func bindTextField() {
        //UI 처리에 특화된 Observable == trait
        //RxCocoa의 Trait. 즉, trait은 ControlProperty, ControlEvent, Driver
            //옵저버블이라 이벤트 전달만 가능하고, 내가 전해주는 이벤트는 볼 수 없기에, 아래 nextbutton bind 구문에서 직접 textField의 text를 바꿨을 때 이를 알 수 없는 것이다.
        nicknameTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                print(#function, "nicknameTextField subscribe: \(value)")
            } onError: { owner, error in
                print(#function, "nicknameTextField onError")
            } onCompleted: { owner in
                print(#function, "nicknameTextField onCompleted")
            } onDisposed: { owner in
                print(#function, "nicknameTextField onDisposed")
            }.disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.nicknameTextField.text = "5"
            })
            .disposed(by: disposeBag)
        
        //publishSubject: 이는 초깃값이 없기에, subscribe가 된 것은 맞으나 viewdidload 실행 시 subscribe 안의 구문이 실행되지는 않는다.
//        publishSubject
//            .subscribe(with: self) { owner, value in
//                print(#function, "publishSubject subscribe: \(value)")
//                print("publishSubject")
//            } onError: { owner, error in
//                print(#function, "publishSubject onError")
//            } onCompleted: { owner in
//                print(#function, "publishSubject onCompleted")
//            } onDisposed: { owner in
//                print(#function, "publishSubject onDisposed")
//            }.disposed(by: disposeBag)
//        
//        behaviorSubject
//            .subscribe(with: self) { owner, value in
//                print(#function, "behaviorSubject subscribe: \(value)")
//                print("behaviorSubject")
//            } onError: { owner, error in
//                print(#function, "behaviorSubject onError")
//            } onCompleted: { owner in
//                print(#function, "behaviorSubject onCompleted")
//            } onDisposed: { owner in
//                print(#function, "behaviorSubject onDisposed")
//            }.disposed(by: disposeBag)

    }
    
    //subscribe vs bind vs drive
    
    //subscribe: next, complete, error
        //앞선 스트림의 스레드 변화 영향 O, 메인 스레드가 아닐 수도
    //bind: next
        //앞선 스트림의 스레드 변화 영향 O, 메인 스레드가 아닐 수도
    //drive: 무조건 main 스레드 실행 보장. 왜냐? Driver 안에 share 연산자를 내장
        // 즉, 앞선 스트림의 스레드 변화 영향 X
        // 또한 스트림이 공유된다.
    func bindButton() {
        //Driver로 바꿔 drive를 사용한다면 Driver() 내부에 share연산자가 적용돼있기에 따로 적지 않아도 스트림을 공유할 수 있어서, map에서 랜덤으로 받은 값을 이를 호출하는 모든 button에서 같은 값을 사용할 수 있는거다.
        let button = nextButton.rx.tap
            .map {print("버튼 클릭")}
            .debug("1")
            .debug("2")
            .debug("3")
            .map {"안녕하세요E \(Int.random(in: 1...100))"}
//            .share() //하나의 subscribe를 공유하도록 도움
            .asDriver(onErrorJustReturn: "") //Driver 타입 안에서 share 연산자가 사용되고 있음.
            //위 스트림의 결과가 에러라면 현재 반환해야하는 string의 default 값 설정
        
        button
            .drive(navigationItem.rx.title)
//            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        button
            .drive(nextButton.rx.title())
//            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        
        button
            .drive(nicknameTextField.rx.text)
//            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    
    func button() {
//        nextButton.rx.tap
//            .subscribe(with: self) { owner, _ in
//                print(#function, "nextButton subscribe")
//            } onError: { owner, error in
//                print(#function, "nextButton onError")
//            } onCompleted: { owner in
//                print(#function, "nextButton onCompleted")
//            } onDisposed: { owner in
//                print(#function, "nextButton onDisposed")
//            }.disposed(by: disposeBag)
        
        //버튼 > 서버통신(비동기) > 응답값 UI 업데이트(main)
        nextButton.rx.tap
            .map {
                print("1", Thread.isMainThread)
            }
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .default)) //이 라인 이후 스트림의 스레드를 원하는대로 바꿔줄 수 있음
            .map {
                print("2", Thread.isMainThread)
            }
            .observe(on: MainScheduler.instance)
            .map {
                print("3", Thread.isMainThread)
            }
            .bind(with: self) { owner, _ in
                print("4", Thread.isMainThread)
                print(#function, "클릭")
            }.disposed(by: disposeBag)
        
        
        nextButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                print("drive")
            }.disposed(by: disposeBag)
    }

    func configureLayout() {
        view.backgroundColor = .white
        
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

