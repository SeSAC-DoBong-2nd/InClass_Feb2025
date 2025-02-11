//// 서버에서 응답값에 대한 키가 갑자기 이상한게 온다면? 갑자기 타입이 바뀐다면?
//// 서버에서 응답값이 일정하지 않다면?
////아래 해결법 참조
//
//// Server -> String -> Data -> Struct : decodable. 디코딩. 역직렬화
//import Foundation
//
//let json = """
//{
//    "product": "도봉캠퍼스 캠핑카",
//    "price": 12345000,
//    "mall": "네이버"
//}
//"""
//
///* # 해결법
// 1. json과 동일한 키를 사용하기
// 2. 런타임 이슈를 방지하기 위한 옵셔널(?) 사용, but 데이터 유실 단점
// 3. CodingKey
// */
//struct Product: Decodable {
//    let item: String
//    let price: Int
//    let mall: String
//    
//    //서버에서 우측 CodingKey가 들어올건데, 좌측 codingKeys의 case와 매핑
//    enum CodingKeys: String, CodingKey {
//        case item = "product"
//        case price
//        case mall
//    }
//}
//
////String -> Data
//guard let result = json.data(using: .utf8) else {
//    fatalError("변환 실패")
//}
//
////Data -> Struct
//do {
//    let value = try JSONDecoder().decode(Product.self, from: result)
//    dump(value)
//} catch {
//    print(error)
//}
