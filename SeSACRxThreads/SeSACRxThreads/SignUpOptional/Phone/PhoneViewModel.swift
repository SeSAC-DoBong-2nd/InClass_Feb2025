//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 박신영 on 2/19/25.
//

import Foundation

import RxCocoa //UIKit이 내장돼있음
import RxSwift

final class PhoneViewModel {
    
    //사용자 인터렉션과 관련된 친구들
    struct Input {
        //버튼 클릭
        let tap: ControlEvent<Void>
        //텍스트필드 글자
        let textFieldText: ControlProperty<String>
    }
    
    struct Output {
        //버튼 클릭
        let tap: ControlEvent<Void>
        //버튼 텍스트
        let buttonTitle: Observable<String>
        //버튼유효성
        let textFieldValidation: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        //buttonTitleText
        let buttonText = Observable.just("연락처는 8자 이상")
        let textFieldValidation = input.textFieldText
            .map { $0.count >= 8 }
        
        return Output(tap: input.tap,
                      buttonTitle: buttonText,
                      textFieldValidation: textFieldValidation)
    }
    
}
