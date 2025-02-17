//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    let disposeBag = DisposeBag()
    
    let emailText = Observable.just("a@a.com")
    let bgColor = Observable.just(UIColor.lightGray)
    
    let signUpTitle = Observable.just("회원이 아니십니까?")
    let signUpTitleColor = Observable.just(UIColor.red)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
//        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        
        //async, stream
        //아래 .별로 상태가 바뀌는 것을 시퀀스가 흘러가며 해당 버튼의 타입가 바뀐다~ 하는 느낌
        signUpButton //UIButton 타입
            .rx //여기부터 ReactiveButton 타입
            .tap //여기부터 ControlEvent 타입
            .bind { _ in //bind == subscribe onNext (UI 이벤트 다룰 때 사용)
                self.navigationController?
                    .pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
//        signUpButton
//            .rx
//            .tap //여기까지 Observable
//            .subscribe { _ in //여기부터 Observer 설정
//                self.navigationController?
//                    .pushViewController(SignUpViewController(), animated: true)
//                print("signUpButton tap onNext")
//            }
//            .disposed(by: disposeBag)

        
        emailText.subscribe { value in
            print("emailText onNext")
            self.emailTextField.text = value
        } onError: { error in
            print("emailText error")
        } onCompleted: {
            print("emailText onCompleted")
        } onDisposed: {
            print("emailText onDisposed")
        }
        .disposed(by: disposeBag)
        
        bindBackgroundColor()
    }
    
    func bindBackgroundColor() {
        bgColor
            .subscribe { value in
                self.view.backgroundColor = value
            } onError: { error in
                print(#function, error)
            } onCompleted: {
                print(#function, "onCompleted")
            } onDisposed: {
                print(#function, "onDisposed")
            }
            .disposed(by: disposeBag)
        
        bgColor
        //  .withUnretained(self) 이 방법 혹은 아래 subscribe에 with 사용하면 순환 참조를 방지할 수 있다.
            .subscribe(with: self) { owner, value in
                owner.view.backgroundColor = value
            } onError: { owner, error in
                print(#function, error)
            } onCompleted: { owner in
                print(#function, "onCompleted")
            } onDisposed: { owner in
                print(#function, "onDisposed")
            }
            .disposed(by: disposeBag)
        
        //호출 되지 않는 이벤트 생략
        bgColor
            .subscribe(with: self) { owner, value in
                owner.view.backgroundColor = value
            }
            .disposed(by: disposeBag)
        
        //이벤트를 받지 못하는 bind로 구현.
          //즉, next만 동작되면 되는 기능이라면 bind로!
        bgColor
            .bind(with: self, onNext: { owner, value in
                owner.view.backgroundColor = value
            })
            .disposed(by: disposeBag)
        
        bgColor
        //to: 다이렉트로 던짐, 받은걸 바로 보여줄 때 사용
        //즉 bind to는 모든 코드가 rx로 변형된 것
            .bind(to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
//    @objc func signUpButtonClicked() {
//        print(#function)
//        navigationController?.pushViewController(SignUpViewController(), animated: true)
//    }
    
    
    func configure() {
        signUpTitle
            .bind(to: signUpButton.rx.title())
            .disposed(by: disposeBag)
        
        signUpTitleColor
        //bind to로 사용하려면 rx에서 지원하는 값을 다룰 수 있을 때 사용됨.
        //현재 button의 titlecolor는 rx에서 제공하고있지 않기에 bind with를 사용함
            .bind(with: self, onNext: { owner, color in
                owner.signUpButton.setTitleColor(color, for: .normal)
            })
            .disposed(by: disposeBag)
        
//        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
//        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
