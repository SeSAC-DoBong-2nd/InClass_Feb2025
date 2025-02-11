import Foundation
//Encoding

//struct -> Data -> String -> Server
struct User {
    let name: String
    let age: Int
}

let jack = User(name: "잭", age: 12)

let encoder = JSONEncoder()
//아래와 같은 다양한 encoding 전략이 있음
//encoder.dateEncodingStrategy
//encoder.keyEncodingStrategy
//encoder.outputFormatting


//아래와 같은 RouterPattern을 많이 써주었지만..
//["page": 1, "language": "ko-KR"]
  //page or language가 서버에서 key가 바뀔 가능성이 있으니 아래와 같이 리터럴한 string 값을 바로 쓰는게 아닌, 해당 값들을 가지고있는 struct를 만들어서 쓰자.


