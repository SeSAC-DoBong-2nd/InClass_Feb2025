//
//  HomeworkViewModel.swift
//  SeSACRxThreads
//
//  Created by 박신영 on 2/20/25.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeworkViewModel {
    
    let disposeBag = DisposeBag() //얘도 프로토콜에 넣을 수 있다. 넣자.
    var items = ["Test님"]
    var recent = ["Test님"]
    
    struct Input {
        let searchButtonTap: ControlEvent<Void> //서치바 엔터키 탭
        let searchText: ControlProperty<String>
        let recentText: PublishSubject<String>
    }
    
    struct Output {
        let items: BehaviorRelay<[String]>
        let recent: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        let itemsList = BehaviorRelay(value: items)
        let recentList = BehaviorRelay(value: recent)
        
        input.searchButtonTap
            .withLatestFrom(input.searchText)
            .map { "\($0)님" }
            .asDriver(onErrorJustReturn: "손님")
            .drive(with: self) { owner, value in
                owner.items.append(value)
                itemsList.accept(owner.items)
            }.disposed(by: disposeBag)
        
        input.recentText
            .bind(with: self) { owner, text in
                owner.recent.append(text)
                recentList.accept(owner.recent)
            }.disposed(by: disposeBag)
        
        return Output(
            items: itemsList,
            recent: recentList.asDriver() //이것도 vc에서 해주기 싫다면 이처럼 가져올 수 있다.
        )
    }
    
}
