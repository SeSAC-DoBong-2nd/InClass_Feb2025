//
//  LoginViewController.swift
//  SeSACSevenWeek
//
//  Created by Jack on 2/5/25.
//
 
import UIKit

import SnapKit

class LoginViewController: UIViewController {
 
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let validationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
      
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureConstraints()
        configureActions()
        
        viewModel.outputIDValidText.lazyBind { value in
            self.validationLabel.text = value
        }
        
        viewModel.outputValidButton.bind { value in
            self.loginButton.isEnabled = value
        }
    }


    @objc private func loginButtonTapped() {
        print(#function)
    }

    @objc private func textFieldDidChange(_ sender: UITextField) {
        print(#function)
        viewModel.inputID.value = idTextField.text
        viewModel.inputPassword.value = passwordTextField.text
    }
    
}

extension LoginViewController {
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(idTextField)
        view.addSubview(passwordTextField)
        view.addSubview(validationLabel)
        view.addSubview(loginButton)
    }

    private func configureConstraints() {
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(20)
            make.left.right.height.equalTo(idTextField)
        }

        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.left.right.equalTo(idTextField)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(validationLabel.snp.bottom).offset(30)
            make.left.right.equalTo(idTextField)
            make.height.equalTo(50)
        }
    }

    private func configureActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        idTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

}
