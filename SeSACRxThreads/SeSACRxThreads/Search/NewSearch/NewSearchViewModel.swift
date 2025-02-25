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
                
                //api 통신 of Single .ver2 (error를 next 이벤트로 보냄)
                NetworkManager.shared.callBoxOfficeWithSingle2(date: $0)
                    
                
                //api 통신 of 옵저버블
//                NetworkManager.shared.callBoxOffice(date: $0)
//                    .debug("movie")
//                    .catch { error in
//                        print("movie error: \(error)")
//                        
//                        let data = Observable.just(Movie(boxOfficeResult: BoxOfficeResult(dailyBoxOfficeList: [])))
//                        return data
//                    }
                    //이와같이 catch로 NetworkManager.shared.callBoxOffice의 error 발생 시 error를 반환하여 searchTap의 구독을 끊지 못하도록, catch 속 클로저문을 구성한다.
                    
                
                //api 통신 of 싱글
//                NetworkManager.shared.callBoxOfficeWithSingle(date: $0)
//                    .debug("movie With Single")
//                    .catch { error in
//                        print("movie error")
//                        
//                        let data = Movie(boxOfficeResult: BoxOfficeResult(dailyBoxOfficeList: []))
//                        return Single.just(data) //single 타입으로 반환하지 않으면 에러
//                        //이 closure 바깥에서 asSingle() 과 같은 변환은 사용하지 말자.
//                            //사용한다면 바깥 'searchTap'도 single 타입이 되고, next or error 이벤트 반환시 dispose가 진행된다.
//                            //즉, 한번만 실행되는 느낌
//                    }
            }
            
            .debug("tap")
            .subscribe(with: self) { owner, value in
                print("searchTap next", value)
                //value의 반환 타입이 Result<Movie, APIError>
                switch value {
                case .success(let movie):
                    list.onNext(movie.boxOfficeResult.dailyBoxOfficeList)
                case .failure(let error):
                    list.onNext([])
                }
                
                
                //그냥 map으로 서버 통신하면 value가 Observable<Movie> 타입이다.
                //flatMap 사용 시 value가 Observable을 벗고 Movie 타입으로 바로 나온다.
//                list.onNext(value.boxOfficeResult.dailyBoxOfficeList)
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
