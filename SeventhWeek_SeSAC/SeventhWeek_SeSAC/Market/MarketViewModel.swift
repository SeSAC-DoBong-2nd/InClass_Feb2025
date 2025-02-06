//
//  MarketViewModel.swift
//  SeSACSevenWeek_2
//
//  Created by Jack on 2/6/25.
//

import Foundation
import Alamofire

final class MarketViewModel {
    
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputCellSelected: Observable<Market?> = Observable(nil)
    let inputIndex: Observable<Int?> = Observable(nil)
    
    let outputTitle: Observable<String?> = Observable(nil)
    let outputMarket: Observable<[Market]> = Observable([])
    let outputCellSelected: Observable<Market?> = Observable(nil)
    
    init() {
        print("MarketViewModel Init")
        
        //api 호출을 두번하지 않기 위해 lazyBind 사용
        inputViewDidLoadTrigger.lazyBind { _ in
            print("inputViewDidLoadTrigger bind")
            
            self.fetchUpbitMarketAPI()
        }
        
        inputCellSelected.lazyBind { market in
            print("inputCellSelected bind")
            self.outputCellSelected.value = market
        }
    }
    
    deinit {
        print("MarketViewModel Deinit")
    }
    
    private func fetchUpbitMarketAPI() {
        let url = "https://api.upbit.com/v1/market/all"
        
        AF.request(url).responseDecodable(of: [Market].self) { response in
            switch response.result {
            case .success(let success):
                dump(success)
                
                self.outputMarket.value = success
                self.outputTitle.value = success.randomElement()?.korean_name
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
