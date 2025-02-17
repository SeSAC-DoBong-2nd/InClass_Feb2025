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
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
         
        bind()
    }
    
    func bind() {
        password
            .bind(to: passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                print("버튼 클릭")
                //password TextField text 값 바꾸기
                
                // = 등호 사용이 왜 안 될까
                    // 옵저버블은 이벤트 전달만 하기 때문.
                    // 즉, 옵저버블 타입의 변수 password는 값을 전달 받을 수 없다.
                    // 따라서 password = "456" 과같은 코드를 쓸 수 없는 것.
                
                //이벤트 전달, 이벤트 처리 둘 다 할 수 있는 친구의 등장!
                    //Subject!!!
                let random = ["칙촉", "56", "케케몬"]
                owner.password.onNext(random.randomElement() ?? "랜덤")
                
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
