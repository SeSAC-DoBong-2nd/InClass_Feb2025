//
//  NumberViewModel.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/5/25.
//

import Foundation

final class NumberViewModel {
    
    //뷰컨에서 사용자가 받아온 값 그 자체
    var inputField: Field<String?> = Field(nil)
    
    //뷰컨 레이블에 보여줄 최종 텍스트
    var outputText = Field("")
    
    //뷰컨에 레이블 텍스트 컬러로 사용할 것
    var outputTextColor: Field<Bool> = Field(false)
    
    init() {
        print("NumberViewModel init")
        inputField.bind { text in
            print("inputField: \(text ?? "실패")")
            self.validation()
        }
    }
    
    private func validation() {
        //공백 - 값을 입력해주세요
        //문자 - 숫자를 입력해주세요
        //숫자 범위 - 100만원 이하의 정수 값을 입력해주세요
        //콤마 - 일정 숫자 단위에 , 찍기
        
        //1) 옵셔널
        guard let text = inputField.value else {
            outputText.value = ""
            outputTextColor.value = false
            return
        }
        
        //2) Empty
        if text.isEmpty {
            outputText.value = "값을 입력해주세요"
            outputTextColor.value = false
            return
        }
        
        //3) 숫자 여부
        guard let num = Int(text) else {
            outputText.value = "숫자만 입력해주세요"
            outputTextColor.value = false
            return
        }
        
        //4) 범위 0~100만
        if num > 0, num <= 1000000 {
            let format = NumberFormatter()
            format.numberStyle = .decimal
            let result = format.string(from: num as NSNumber) ?? ""
            outputText.value = "W " + result
            outputTextColor.value = true
            // 해당 방법도 가능
            // formattedAmountLabel.text = "W " + num.formatted()
        } else {
            outputText.value = "백만원 이하의 정수 값을 입력해주세요"
            outputTextColor.value = false
        }
    }
    
}
