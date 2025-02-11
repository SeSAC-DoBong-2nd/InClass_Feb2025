// 서버에서 응답값에 대한 키가 갑자기 이상한게 온다면? 갑자기 타입이 바뀐다면?
// 서버에서 응답값이 일정하지 않다면?
//아래 해결법 참조

// Server -> String -> Data -> Struct : decodable. 디코딩. 역직렬화
import Foundation

let json = """
{
    "product": "도봉캠퍼스 캠핑카",
    "price": 12345000,
    "mall": "네이버"
}
"""

/* # 해결법
 1. json과 동일한 키를 사용하기
 2. 런타임 이슈를 방지하기 위한 옵셔널(?) 사용, but 데이터 유실 단점
 3. CodingKey로 서버 키와 다른 키를 매핑
 4. 디코딩 전략
 - 1) 스네이크케이스 (= 서버에서 오는 스네이크 케이스를 카멜케이스로 바꿔줌)
 - 2) 커스텀 디코딩
   - +@ optional 대응
     만약 서버에서 price가 Int? 일때 아래와 같이 decodeIfPresent로 해결하면 옵셔널로 값이 들어오더라도 옵셔널 바인딩을 사용하기에 나의 responseModel은 Int로 설정해도 된다.
 */
struct Product: Decodable {
    let item: String
    let price: Int
    let mall: String
    let influencer: Bool
    
    enum CodingKeys: String, CodingKey {
        case item = "product"
        case price
        case mall
    }
    
    //커스텀 디코딩 전략
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        item = try container.decode(String.self, forKey: .item)
        
        //optional을 대응할 때 사용 = decodeIfPresent
        price = try container.decodeIfPresent(Int.self, forKey: .price) ?? 0
        
        mall = try container.decode(String.self, forKey: .mall)
        influencer = (10000000..<20000000).contains(price) ? true : false
    }
}

//String -> Data
guard let result = json.data(using: .utf8) else {
    fatalError("변환 실패")
}

let decoder = JSONDecoder()
//해결법 4-1)
decoder.keyDecodingStrategy = .convertFromSnakeCase

//Data -> Struct
do {
    let value = try decoder.decode(Product.self, from: result)
    dump(value)
} catch {
    print(error)
}
