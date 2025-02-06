//
//  BoxOffice.swift
//  SeSACSevenWeek_2
//
//  Created by Jack on 2/6/25.
//

import Foundation

struct BoxOfficeResult: Codable {
    let boxOfficeResult: DailyBoxOffice
}

struct DailyBoxOffice: Codable {
    let dailyBoxOfficeList: [Movie]
}

struct Movie: Codable {
    let rank: String
    let movieNm: String
    let audiCnt: String
}
