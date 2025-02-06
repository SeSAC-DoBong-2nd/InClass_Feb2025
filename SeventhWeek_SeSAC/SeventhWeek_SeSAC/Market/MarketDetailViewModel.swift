//
//  MarketDetailViewModel.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/6/25.
//

import Foundation

final class MarketDetailViewModel {
    
//    var outputOneMarket: Observable<Market?> = Observable(nil)
    
    //if korea name만 사용
    var outputOneMarket: Observable<String?> = Observable(nil)
    
    
    init() {
        print("MarketDetailViewModel init")
    }
    
    deinit {
        print("MarketDetailViewModel deinit")
    }
    
}
