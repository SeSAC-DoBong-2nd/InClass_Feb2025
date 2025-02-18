//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다시")
    var password = BehaviorSubject(value: "1234")
    var disposeBag = DisposeBag()
    
    //Schedular == Main or Global
    let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    
    deinit {
        //with: self 를 사용하고 owner 대신 클로저 구문에 self를 사용한다면 순환참조, 메모리 누수가 발생해서 deinit이 되지 않는다.
        //Deinit이 될 때 구독이 정상적으로 해제된다. == Dispose된 상태
        // => 왜 VC가 deinit 되면 dispose가 되는 걸까?
            // = vc에서 let disposeBag = DisposeBag()를 갖고있기에 vc가 사라지면 인스턴스도 사라짐.
        print("password Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
         
        bind()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.disposeBag = DisposeBag()
        }
    }
    
    func bind() {
        
        //이와 같이 프로퍼티에 코드를 담으면 구독 해제하는 시점으로 수동으로 조절 가능하다.
//        let incrementValue = timer
        
        timer
            .subscribe(with: self) { owner, value in
                print("Timer", value) //next 이벤트
            } onError: { owner, error in
                print("Timer error", error) //error 이벤트
            } onCompleted: { owner in
                print("Timer onCompleted") //completed 이벤트
            } onDisposed: { owner in
                print("Timer onDisposed")
            }
            .disposed(by: disposeBag)
        
        password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap //이벤트 전달, 옵저버블, next, ui관련 따라서 infinite는 bind 사용
            .bind(with: self) { owner, _ in
                print("버튼 클릭")
                
                //수동으로 개별적인 옵저버블 관리
//                incrementValue.dispose()
                
                //password TextField text 값 바꾸기
                
                // = 등호 사용이 왜 안 될까
                    // 옵저버블은 이벤트 전달만 하기 때문.
                    // 즉, 옵저버블 타입의 변수 password는 값을 전달 받을 수 없다.
                    // 따라서 password = "456" 과같은 코드를 쓸 수 없는 것.
                
                //이벤트 전달, 이벤트 처리 둘 다 할 수 있는 친구의 등장!
                    //Subject!!!
                let random = ["칙촉", "56", "케케몬"]
                owner.password.onNext(random.randomElement() ?? "랜덤")
                
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
                
            }.disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PhoneViewController(), animated: true)
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
