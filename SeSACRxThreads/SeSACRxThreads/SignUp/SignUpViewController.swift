//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    
    let emailPlaceholder = Observable.just("이메일을 입력해주세요.")
    
    var disposeBag = DisposeBag()
    
    func bind() {
        //emailTextfield
        //4자리 이상: 다음 버튼 나타나고, 중복확인 버튼 눌리도록
        //4자리 미만: 다음 버튼 안 보이고, 중복확인 버튼 click X
        //orEmpty = 옵셔널 풀어줌
        let validation = emailTextField
            .rx
            .text
            .orEmpty
            .map { $0.count >= 4 }
            
//        validation
//            .bind(with: self) { owner, value in
//                //orEmpty를 안 쓰면 클로저구문 안에서 옵셔널 바인딩을 써야함
////                guard let value = value else {return }
//        }.disposed(by: disposeBag)
        
//        validation
//            .bind(to: nextButton.rx.isHidden)
//            .disposed(by: disposeBag)
        
//        validation
//            .bind(to: validationButton.rx.isEnabled)
//            .disposed(by: disposeBag)
        
        validation
            .subscribe(with: self, onNext: { owner, value in
                owner.validationButton.isEnabled = value
                print("Validation Next")
            }, onDisposed:  { owner in
                print("Validation Disposed")
            })
            //dispose 사용 시 옵저버블 - 옵저버 사이가 끊김.
            //dispose는 곧바로 구독을 취소시킴. 그래서 disposed를 사용
            //disposed()는 disposeBag 프로퍼티가 초기화 될 때 구독 취소됨
            //따라서 vc의 deinit 시점에 disposeBag을 초기화 하는게 가장 이상적
            .disposed(by: disposeBag)
                
        
        validationButton.rx.tap
            .bind(with: self) { owner, _ in
                print(#function)
                owner.disposeBag = DisposeBag()
        }
        
        emailPlaceholder
            .bind(to: emailTextField.rx.placeholder)
            .disposed(by: disposeBag)
    }
    
    func operatorExample() {
        let itemA = [3, 5, 23, 8, 10]
        
        Observable.just(itemA)
            .subscribe(with: self) { owner, value in
                print("Just \(value)")
            } onError: { owner, error in
                print("Just \(error)")
            } onCompleted: { owner in
                print("Just onCompleted")
            } onDisposed: { owner in
                print("Just onDisposed")
            }.disposed(by: disposeBag)
        
        Observable.from(itemA)
            .subscribe(with: self) { owner, value in
                print("from \(value)")
            } onError: { owner, error in
                print("from \(error)")
            } onCompleted: { owner in
                print("from onCompleted")
            } onDisposed: { owner in
                print("from onDisposed")
            }.disposed(by: disposeBag)
        
        Observable.repeatElement(itemA)
            .take(10)
            .map { $0.map { $0 * 2 } }
            .subscribe(with: self) { owner, value in
                print("repeatElement \(value)")
            } onError: { owner, error in
                print("repeatElement \(error)")
            } onCompleted: { owner in
                print("repeatElement onCompleted")
            } onDisposed: { owner in
                print("repeatElement onDisposed")
            }.disposed(by: disposeBag)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        
        bind()
        operatorExample()
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
