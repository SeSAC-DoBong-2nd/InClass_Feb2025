//
//  NewBirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 박신영 on 2/19/25.
//

import Foundation

import RxCocoa
import RxSwift

final class NewBirthdayViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let birthday: ControlProperty<Date>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let nextTap: ControlEvent<Void>
        let year: BehaviorRelay<Int>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
    }
    
    func transfrom(input: Input) -> Output {
        let year = BehaviorRelay(value: 2025)
        let month = BehaviorRelay(value: 2)
        let day = BehaviorRelay(value: 19)
        
        input.birthday
            .bind { date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date) //.weekOfMonth: 요일을 다룸
                
                print(component.year ?? 0)
                print(component.month ?? 0)
                print(component.day ?? 0)
                
                year.accept(component.year ?? 0)
                month.accept(component.month ?? 0)
                day.accept(component.day ?? 0)
            }
            .disposed(by: disposeBag)
        
        return Output(
            nextTap: input.nextTap,
            year: year,
            month: month,
            day: day
        )
    }
    
}
