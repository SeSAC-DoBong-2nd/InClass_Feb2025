//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by 박신영 on 2/24/25.
//

import Foundation

import RxCocoa
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

struct Movie: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

// MARK: - BoxOfficeResult
struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

// MARK: - DailyBoxOfficeList
struct DailyBoxOfficeList: Decodable {
    let movieNm, openDt: String
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    //error가 발생해도 next 이벤트를 보내 주 옵저버블 스트림이 끊기지 않도록 하자
    //Single 속에서 다루는 타입을 Result<Moview, APIError>로 만들어 다루자!
        //이러면 single의 입장에서는 .success를 보내 next 이벤트가 발동되도록 하여 주 옵저버블의 스트림이 에러를 받지 않도록 한다.
    func callBoxOfficeWithSingle2(date: String) -> Single<Result<Movie, APIError>> {
        
        //return으로 옵저버블 무비 값을 받아와 활용할 것이다.
        return Single<Result<Movie, APIError>>.create { value in
            let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=b732b92527fcc43dd22b4410bc85fcb3&targetDt=\(date)"
            
            guard
                let url = URL(string: urlString)
            else {
                value(.success(.failure(.invalidURL))) //기존 아래 코드를 이처럼 수정함
//                value(.failure(APIError.invalidURL))
                return Disposables.create { //클로저 있는 형태는 dispose 됐을 때 신호받으려고 씀
                    print("url 에러로 끝")
                }
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    value(.success(.failure(.unknownResponse)))
                    return
                } else {
                    guard
                        let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
                    else {
                        value(.success(.failure(.statusError)))
                        return
                    }
                    if let data = data {
                        do {
                            let result = try
                            JSONDecoder().decode(Movie.self, from: data)
//                            value(.success(.failure(.unknownResponse))) 
                            value(.success(.success(result)))
                        } catch {
                            //디코딩 실패 에러
                            value(.success(.failure(.unknownResponse)))
                        }
                    } else {
                        //data 없는 에러
                        value(.success(.failure(.unknownResponse)))
                    }
                }
            }.resume()
            
            return Disposables.create {
                print("끝~")
            }
        }
    }
    
    //next이벤트 끝나면 컴플리트를 자동으로 해줌.
    func callBoxOfficeWithSingle(date: String) -> Single<Movie> {
        
        //return으로 옵저버블 무비 값을 받아와 활용할 것이다.
        return Single<Movie>.create { value in
            let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=b732b92527fcc43dd22b4410bc85fcb3&targetDt=\(date)"
            
            guard
                let url = URL(string: urlString)
            else {
                value(.failure(APIError.invalidURL))
                return Disposables.create { //클로저 있는 형태는 dispose 됐을 때 신호받으려고 씀
                    print("url 에러로 끝")
                }
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    value(.failure(APIError.unknownResponse))
                    return
                } else {
                    guard
                        let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
                    else {
                        value(.failure(APIError.statusError))
                        return
                    }
                    if let data = data {
                        do {
                            let result = try
                            JSONDecoder().decode(Movie.self, from: data)
                            value(.failure(APIError.unknownResponse))
                            value(.success(result))
                        } catch {
                            //디코딩 실패 에러
                            value(.failure(APIError.unknownResponse))
                        }
                    } else {
                        //data 없는 에러
                        value(.failure(APIError.unknownResponse))
                    }
                }
            }.resume()
            
            return Disposables.create {
                print("끝~")
            }
        }
    }
    
    func callBoxOffice(date: String) -> Observable<Movie> {
        
        //return으로 옵저버블 무비 값을 받아와 활용할 것이다.
        return Observable<Movie>.create { value in
            let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=b732b92527fcc43dd22b4410bc85fcb3&targetDt=\(date)"
            
            guard
                let url = URL(string: urlString)
            else {
                value.onError(APIError.invalidURL)
                return Disposables.create { //클로저 있는 형태는 dispose 됐을 때 신호받으려고 씀
                    print("url 에러로 끝")
                }
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    value.onError(APIError.unknownResponse)
                    return
                } else {
                    guard
                        let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
                    else {
                        value.onError(APIError.statusError)
                        return
                    }
                    if let data = data {
                        do {
                            let result = try
                            JSONDecoder().decode(Movie.self, from: data)
                            value.onError(APIError.unknownResponse)
                            value.onNext(result)
                            value.onCompleted() //next 이벤트는 dispose 되지 않으니 이후 completed를 사용해줘야한다.
                        } catch {
                            //디코딩 실패 에러
                            print("1")
                            value.onError(APIError.unknownResponse)
                        }
                    } else {
                        //data 없는 에러
                        print("2")
                        value.onError(APIError.unknownResponse)
                    }
                }
            }.resume()
            
            return Disposables.create {
                print("끝~")
            }
        }
    }
    
//    func callBoxOffice<T>(date: String,responseModel: T, completionHandler: @escaping (Result<T.Type, APIError>) -> Void) {
//        let urlString = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=b732b92527fcc43dd22b4410bc85fcb3&targetDt=\(date)"
//        
//        guard
//            let url = URL(string: urlString)
//        else {
//            completionHandler(.failure(.invalidURL))
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if error == nil {
//                completionHandler(.success("훈공!"))
//            } else {
//                completionHandler(.failure(.statusError))
//            }
//        }
//    }
    
}
