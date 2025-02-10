//
//  NumberViewModel.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/5/25.
//

import Foundation

/*
 viewModel을 통해 UI 로직과 비즈니스 로직을 분리
 비즈니스 로직도 input, output으로 분리
 
 
 mvc -> mvvm으로 추세가 바뀐이유
 : vc의 비대성을 해결하기 위해
   -> 그럼 vm이 vc 코드 받아서 비대해지지 않나?
     -> 사용자가 사용하는 화면을 담당하는 vc의 절대적인 코드가 줄었기에 더 효율적?
 */

final class NumberViewModel: BaseViewModelProtocol {
    
    //VC가 VM의 input, output 프로퍼티만 알고있는 상황
    //즉, VC가 VM에 접근할 수 있는 프로퍼티의 개수를 줄임
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        //뷰컨에서 사용자가 받아온 값 그 자체
        var field: Field<String?> = Field(nil)
    }
    
    struct Output {
        //뷰컨 레이블에 보여줄 최종 텍스트
        var fieldText = Field("")
        //뷰컨에 레이블 텍스트 컬러로 사용할 것
        var fieldTextColor: Field<Bool> = Field(false)
    }
    
    init() {
        print("NumberViewModel init")
        
        input = Input()
        output = Output()
        
        transform()
    }
    
    internal func transform() {
        input.field.bind { text in
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
        guard let text = input.field.value else {
            output.fieldText.value = ""
            output.fieldTextColor.value = false
            return
        }
        
        //2) Empty
        if text.isEmpty {
            output.fieldText.value = "값을 입력해주세요"
            output.fieldTextColor.value = false
            return
        }
        
        //3) 숫자 여부
        guard let num = Int(text) else {
            output.fieldText.value = "숫자만 입력해주세요"
            output.fieldTextColor.value = false
            return
        }
        
        //4) 범위 0~100만
        if num > 0, num <= 1000000 {
            let format = NumberFormatter()
            format.numberStyle = .decimal
            let result = format.string(from: num as NSNumber) ?? ""
            output.fieldText.value = "W " + result
            output.fieldTextColor.value = true
            // 해당 방법도 가능
            // formattedAmountLabel.text = "W " + num.formatted()
        } else {
            output.fieldText.value = "백만원 이하의 정수 값을 입력해주세요"
            output.fieldTextColor.value = false
        }
    }
    
}
