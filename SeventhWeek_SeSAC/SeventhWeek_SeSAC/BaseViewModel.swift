//
//  BaseViewModel.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/10/25.
//

import Foundation

//generic: 호출 시 타입이 결정.
//protocol에서 generic은 T를 사용하지 않고, associatedType을 사용함.
protocol Calculator {
    
    //generic T에 제약을 거는 것과 같이 associatedType에도 제약을 걸 수 있음.
    associatedtype T: Numeric
    
    
//    func plus(a: T, b: T) -> T {
//        return a + b
//    }
}


// 인터페이스
protocol BaseViewModelProtocol {
    //Input, Output이 어떤 타입으로든 해당 프로토콜을 채택한 곳에서 존재하기만 하면 된다.
    associatedtype Input
    associatedtype Output
    
    func transform()
}

// 구체적으로 명세할 경우 typealias 필요 X
// 구체적으로 명세하지 않는다면 아래와 같이 typealias로 별칭 설정
class Sample: BaseViewModelProtocol {

    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform() {
        
    }
    
    
}


protocol Mentor {
    associatedtype Jack
    
    func hello(a: Jack)
}

class Test: Mentor {
    
    typealias Jack = String
    
    func hello(a: Jack) {
        
    }
    
}
