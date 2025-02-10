//
//  NumberViewController.swift
//  SeSACSevenWeek
//
//  Created by Jack on 2/5/25.
//

import UIKit

import SnapKit

//1. init
//2. didset
//3. closure
//4. init
final class Field<T> {
    
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(self.value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    //bind에 작성한 구문이 init과 동시에 동작하게끔 하고 싶은 경우
    func bind(closure: @escaping (T) -> Void) {
        closure(value) // init 시점에 실행할 수 있도록 함
        self.closure = closure
    }
    
    //bind에 작성한 구문이 값이 변경되었을 때 동작하게끔 하고 싶은 경우
    func lazyBind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
    
}

final class NumberViewController: UIViewController {

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "금액 입력"
        textField.keyboardType = .numberPad
        return textField
    }()
    private let formattedAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "값을 입력해주세요"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let viewModel = NumberViewModel()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureConstraints()
        configureActions()
        
        viewModel.output.fieldText.bind { text in
            self.formattedAmountLabel.text = text
        }
        
        viewModel.output.fieldTextColor.bind { flag in
            self.formattedAmountLabel.textColor = flag ? .blue : .red
        }
    }
 
 
    @objc
    private func amountChanged() {
        print(#function)
        
        viewModel.input.field.value = amountTextField.text
        
        
    }
    
}

extension NumberViewController {
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(amountTextField)
        view.addSubview(formattedAmountLabel)
    }

    private func configureConstraints() {
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        formattedAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.left.right.equalTo(amountTextField)
        }
    }

    private func configureActions() {
        amountTextField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
    }

}
