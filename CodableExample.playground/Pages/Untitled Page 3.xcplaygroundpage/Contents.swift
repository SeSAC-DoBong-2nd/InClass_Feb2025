//// 서버에서 응답값에 대한 키가 갑자기 이상한게 온다면? 갑자기 타입이 바뀐다면?
//// 서버에서 응답값이 일정하지 않다면?
////아래 해결법 참조
//
//// Server -> String -> Data -> Struct : decodable. 디코딩. 역직렬화
//import Foundation
//
//let json = """
//{
//    "product_name": "도봉캠퍼스 캠핑카",
//    "price": 12345000,
//    "mall_name": "네이버"
//}
//"""
//
///* # 해결법
// 1. json과 동일한 키를 사용하기
// 2. 런타임 이슈를 방지하기 위한 옵셔널(?) 사용, but 데이터 유실 단점
// 3. CodingKey로 서버 키와 다른 키를 매핑
// 4. 디코딩 전략 - 1) 스네이크케이스 (= 서버에서 오는 스네이크 케이스를 카멜케이스로 바꿔줌)
// */
//struct Product: Decodable {
//    let productName: String
//    let price: Int
//    let mallName: String
//}
//
////String -> Data
//guard let result = json.data(using: .utf8) else {
//    fatalError("변환 실패")
//}
//
//let decoder = JSONDecoder()
////해결법 4-1)
//decoder.keyDecodingStrategy = .convertFromSnakeCase
//
////Data -> Struct
//do {
//    let value = try decoder.decode(Product.self, from: result)
//    dump(value)
//} catch {
//    print(error)
//}
