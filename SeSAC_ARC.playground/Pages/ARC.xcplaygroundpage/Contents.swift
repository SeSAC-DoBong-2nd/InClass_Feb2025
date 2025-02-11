import UIKit

//클래스, 구조체, 열거형 등에 다 사용가능
//따라서 해당 프로토콜에 대한 delegate는 weak 키워드를 사용할 수 없음
//protocol JackProtocolAll: {
//    func numberOfRowsInSection()
//}

//AnyObhect로 막아뒀기에 클래스만 가능
//따라서 해당 프로토콜에 대한 delegate에 힙 영역의 메모리를 다루는 weak, unowned 등 키워드를 사용할 수 있다.
protocol JackProtocol: AnyObject {
    func numberOfRowsInSection()
}

class Main: JackProtocol {
    
    func numberOfRowsInSection() {
        print(#function)
    }
    
    lazy var detail = {
        let view = Detail()
        print("Detail 클로저 즉시 실행")
        view.delegate = self //원래는 Main class의 detail 인스턴스가 Detail의 delegate를 참조하기에 Detail의 RC가 +1 돼야하나, 아래 Detail의 delegate 프로퍼티에 weak 키워드를 사용했기에 RC가 증가되지 않음.
        return view
    }()
    
    init() {
        print("Main init")
    }
    
    deinit {
        print("Main deinit")
    }
    
}

/* 2개의 예시 case
 tableview, collectionview 느낌
 = 프로토콜 기반 역값전달
 
 person property의 name
 = 클로저 구문
 */

class Detail {
    
    //weak -> rc 증가 X -> rc는 힙에서 관리 -> 힙 영역은 참조타입 (클래스, 클로저)
    weak var delegate: JackProtocol? //RC 증가 X
    
    func setup() {
        print(#function)
        delegate?.numberOfRowsInSection()
    }
    
    init() {
        print("Detail init")
    }
    
    deinit {
        print("Detail deinit")
    }
    
}

var main: Main? = Main()
main?.detail
main = nil
main?.detail

//class Person {
//    
//    var name: String
//    
//    //self.name: Jack 인스턴스가 없어져도 name 프로퍼티는 살아있는 상황
//    lazy var introduce = {
//        print("Introduce", self.name)
//    }
//    
//    init(name: String) { // 인스턴스 생성 시점
//        print("Person init")
//        self.name = name
//    }
//    
//    deinit {
//        print("Person deinit")ㅇ
//    }
//    
//    func Hello() {
//        print(#function)
//    }
//    
//}
//
//// ARC: Automatic Reference Count
//// Swift 메모리 관리 기법
//var jack: Person? = Person(name: "Jack")
//jack?.name = "Hue"
//jack?.name
//jack?.Hello()
//jack?.introduce()
//let newIntroduce = jack?.introduce
//newIntroduce?()
//
//jack = nil // 인스턴스 해제 시점
//jack // jack이 nil 인 것은 Jack 인스턴스 메모리가 X라는 뜻
//jack?.name
//jack?.Hello()
//jack?.introduce()
//newIntroduce?()
