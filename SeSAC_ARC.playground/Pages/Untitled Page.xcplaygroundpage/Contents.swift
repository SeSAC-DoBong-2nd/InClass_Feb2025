import Foundation

func plus(num: Int) -> (() -> Int) {
    var total = 0
    
    func calculate() -> Int { // () -> Int
        return total + num
    }
    
    return calculate
}

let a = plus(num: 9)
a()
a()
a()


func firstClosure() {
    
    var number = 0
    
    print("1", number)
    
    //클로저 캡쳐리스트
    //클로저: 값을 캡쳐할 때 참조타입으로 캡쳐 (Reference Capture)
    //[number] 와 같이 클로저 헤드에 사용한다면 number의 값을 복사해서 사용할 수 있음.
      // => 독립형태로 값을 쓸 수 있음
    let myClosure = { [number] in
        print("myClosure", number)
    }
    
    number = 100
    
    myClosure()
    
    print("2", number)
    
}

firstClosure()



//클로저 캡쳐리스트
//let myClosure = { [number] in
//    print("myClosure", number)
//}
