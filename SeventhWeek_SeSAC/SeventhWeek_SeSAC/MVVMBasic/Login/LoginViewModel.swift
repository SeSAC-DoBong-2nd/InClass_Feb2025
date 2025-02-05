//
//  LoginViewModel.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/5/25.
//

import Foundation

final class LoginViewModel {
    
    //실시간으로 달라지는 텍스트필드의 값을 전달받아옴!
    let inputID: Field<String?> = Field(nil)
    let inputPassword: Field<String?> = Field(nil)
    
    //텍스트만 레이블로 보내기
    let outputIDValidText = Field("유효성 레이블")
    //버튼 Enabled 상태 관리
    let outputValidButton = Field(false)
    
    init() {
        inputID.bind { _ in
            print("inputID Bind")
            self.validation()
        }
        
        inputPassword.bind { _ in
            print("inputPassword Bind")
            self.validation()
        }
    }
    
    func validation() {
        guard let id = inputID.value, let pw = inputPassword.value
        else {
            outputIDValidText.value = "nil 입니다"
            outputValidButton.value = false
            return
        }
        if id.count >= 4 && pw.count >= 4 {
            outputIDValidText.value = "Good Bro"
            outputValidButton.value = true
        } else {
            outputIDValidText.value = "아이디, 비밀번호 둘 다 4자리 이상입니다."
            outputValidButton.value = false
        }
    }
    
}
