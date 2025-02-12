import Foundation
//Encoding

//struct -> Data -> String -> Server
struct User: Encodable {
    let name: String
    let age: Int
    let birth: Date
}

let jack = [
    User(name: "잭", age: 12, birth: Date()),
    User(name: "캑", age: 13, birth: Date(timeInterval: -86400, since: .now)),
    User(name: "콕", age: 14, birth: Date(timeIntervalSinceNow: 86400))
]

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted //jsonData 출력 시 예쁘게 보여줌
encoder.outputFormatting = .sortedKeys // jsonData Key 값 오름차순 정렬
let format = DateFormatter()
format.dateFormat = "MM월 dd일 yyyy년"
encoder.dateEncodingStrategy = .formatted(format) // jsonData의 Date 인코딩 전략(타입 변환)

do {
    let result = try encoder.encode(jack)
    print(result)
    
    //json은 순서가 중요치 않음. 안의 값만 일치하면 됨
    guard let jsonString = String(data: result, encoding: .utf8) else { fatalError("Error")
    }
    print(jsonString)
} catch {
    print(error)
}







//아래와 같은 다양한 encoding 전략이 있음
//encoder.dateEncodingStrategy
//encoder.keyEncodingStrategy
//encoder.outputFormatting


//아래와 같은 RouterPattern을 많이 써주었지만..
//["page": 1, "language": "ko-KR"]
  //page or language가 서버에서 key가 바뀔 가능성이 있으니 아래와 같이 리터럴한 string 값을 바로 쓰는게 아닌, 해당 값들을 가지고있는 struct를 만들어서 쓰자.


