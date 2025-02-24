//
//  NewSearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 박신영 on 2/24/25.
//

import Foundation

import RxCocoa
import RxSwift

final class NewSearchViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let list: Observable<[DailyBoxOfficeList]>
    }
    
    //map, withLatestFrom, flatMap, FlatMapLatest 등등
    func transform(input: Input) -> Output {
        let list = PublishSubject<[DailyBoxOfficeList]>()
        
        //20250101
        input.searchTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let text = Int($0) else {
                    return 20250223
                }
                return text //만약 map이 return 값을 뱉어낼 수 없는 상황 즉, void를 갖고있을 때에는 어떻게 return을 할 수 있도록 만들 수 있을까
            }
            .map { return "\($0)" }
            .flatMap { //map 과의 차이점 아래에 있으니 인지하자.
//                NetworkManager.shared.callBoxOffice(date: $0).debug("movie")
                NetworkManager.shared.callBoxOfficeWithSingle(date: $0).debug("moview With Single")
            }
            .debug("tap")
            .subscribe(with: self) { owner, value in
                //그냥 map으로 서버 통신하면 value가 Observable<Movie> 타입이다.
                //flatMap 사용 시 value가 Observable을 벗고 Movie 타입으로 바로 나온다.
                list.onNext(value.boxOfficeResult.dailyBoxOfficeList)
            } onError: { owner, error in
                print("onError")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }.disposed(by: disposeBag)

        
        return Output(list: list)
    }
    
}
