//
//  BoxOfficeViewModel.swift
//  SeSACSevenWeek_2
//
//  Created by Jack on 2/6/25.
//

import Foundation

import Alamofire

final class BoxOfficeViewModel {
    
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        let selectedDate: Observable<Date> = Observable(Date())
        let searchButtonTapped: Observable<Void?> = Observable(nil)
    }
    
    struct Output {
        let selectedDate: Observable<String> = Observable("")
        let boxOffice: Observable<[Movie]> = Observable([])
    }
    
    private var query = ""
     
    init() {
        print("BoxOfficeViewModel Init")
        input = Input()
        output = Output()
         
        transform()
    }
    
    deinit {
        print("BoxOfficeViewModel Deinit")
    }
    
    private func transform() {
        input.selectedDate.bind { date in
            self.convertDate(date: date)
        }
        
        input.searchButtonTapped.bind { _ in
            self.callBoxOfficeURLSession(date: self.query)
            print("=========", self.query)
        }
    }
    
    private func convertDate(date: Date) {
        let formatted = DateFormatter()
        formatted.dateFormat = "yy년 MM월 dd일"
        let string = formatted.string(from: date)
        output.selectedDate.value = string
        
        let format2 = DateFormatter()
        format2.dateFormat = "yyyyMMdd"
        let query = format2.string(from: date)
        self.query = query
    }
    
    private func callBoxOffice(date: String) {
        let apikey = Bundle.main.apiKey ?? ""
        let url = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(apikey)&targetDt=\(date)"
        
        AF.request(url).responseDecodable(of: BoxOfficeResult.self) { response in
            switch response.result {
            case .success(let success):
                dump(success.boxOfficeResult.dailyBoxOfficeList)
                self.output.boxOffice.value = success.boxOfficeResult.dailyBoxOfficeList
                print("=======call boxoffic=========")
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    private func callBoxOfficeURLSession(date: String) {
        print(#function)
        let apikey = Bundle.main.apiKey ?? ""
        let url = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(apikey)&targetDt=\(date)"
        let request = URLRequest(url: URL(string: url)!)
        
        print("===1: \(Thread.isMainThread)")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            //여기부터 main 스레드가 아니다.
            //즉, urlsession의 task 클로저 영역 속 부터 background 스레드에서 동작한다.
            //클로저 부분은 무조건 글로벌 스레드
            print("===2: \(Thread.isMainThread)")
            
            //error가 nil이 아닐경우 예외처리
            if let errorText = error?.localizedDescription {
                print("오류 발생: \(errorText)")
                return
            }
            
            //상태코드 예외처리
            guard
                let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode)
            else {
                print("상태코드 대응")
                return
            }
            
            //Data 디코딩
            // do try catch - error handling ->
            // server > client
            // 위 내용은 15회차 or 20회차
            /*
             tmdb json > 키가 없는 경우.. nil..
             */
            if let data = data, let movieData = try? JSONDecoder().decode(BoxOfficeResult.self, from: data) {
                dump(movieData)
                DispatchQueue.main.async {
                    self.output.boxOffice.value = movieData.boxOfficeResult.dailyBoxOfficeList
                }
            } else {
                print("data가 없거나 movie decoding을 실패했거나")
                return
            }
            
            
        }.resume() // 이 친구 없으면 통신 조차 되지 않음 == 신호탄
    }
    
    private func callNasaAPI() {
        
    }
    
}
