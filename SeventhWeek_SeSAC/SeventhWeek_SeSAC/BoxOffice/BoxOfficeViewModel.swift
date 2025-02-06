//
//  BoxOfficeViewModel.swift
//  SeSACSevenWeek_2
//
//  Created by Jack on 2/6/25.
//

import Foundation

import Alamofire

class BoxOfficeViewModel {
    
    let inputSelectedDate: Observable<Date> = Observable(Date())
    let inputSearchButtonTapped: Observable<Void?> = Observable(nil)
    
    let outputSelectedDate: Observable<String> = Observable("")
    
    let outputBoxOffice: Observable<[Movie]> = Observable([])
//    = [Movie(rank: "10", movieNm: "테스트", audiCnt: "123")]
    
    private var query = ""
     
    init() {
        print("BoxOfficeViewModel Init")
         
        inputSelectedDate.bind { date in
            self.convertDate(date: date)
        }
        
        inputSearchButtonTapped.bind { _ in
            self.callBoxOffice(date: self.query)
            print("=========", self.query)
        }
    }
    
    deinit {
        print("BoxOfficeViewModel Deinit")
    }
    
    private func convertDate(date: Date) {
        let formatted = DateFormatter()
        formatted.dateFormat = "yy년 MM월 dd일"
        let string = formatted.string(from: date)
        outputSelectedDate.value = string
        
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
                  self.outputBoxOffice.value = success.boxOfficeResult.dailyBoxOfficeList
                  print("=======call boxoffic=========")
              case .failure(let failure):
                  print(failure)
              }
          }
      }
    
}
