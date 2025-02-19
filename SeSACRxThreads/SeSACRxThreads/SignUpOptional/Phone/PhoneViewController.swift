//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit

import RxSwift
import RxCocoa
import SnapKit

class PhoneViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    private let viewModel: PhoneViewModel
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    init(viewModel: PhoneViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
    }
    
    func bind() {
        //input으로 보내야 하는 것들
//        nextButton.rx.tap
//        phoneTextField.rx.text.orEmpty
        
        //vc에서 vm으로 보내는 input이 몇개인지 여기서 정리한다면 일원화 시켜 한 눈에 파악 가능하다
        let input = PhoneViewModel.Input(tap: nextButton.rx.tap,
                                         textFieldText: phoneTextField.rx.text.orEmpty)
        
        let output = viewModel.transform(input: input)
        
        output.tap
            .bind(with: self) { owner, _ in
                print("버튼이 클릭되었습니다.")
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.buttonTitle
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        
        output.textFieldValidation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
