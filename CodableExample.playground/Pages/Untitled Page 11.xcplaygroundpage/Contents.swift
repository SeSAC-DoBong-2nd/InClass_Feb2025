//# PropertyWrapper
//사용이유: 어차피 반복될거 하나도 합치면 안되나?!

import Foundation

//제네릭 사용
struct JackDefaults<T> {
    let key: String
    let empty: T
    
    var myValue: T {
        get {
            //object: 정해져있는 타입 없이 Any 타입을 다룸.
            // 따라서 as? 와 같이 타입캐스팅
            UserDefaults.standard.object(forKey: key) as? T ?? empty
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

var age = JackDefaults(key: "age", empty: 16)
let first = JackDefaults(key: "first", empty: false)
var nick = JackDefaults(key: "nick", empty: "고래밥")

age.myValue
age.myValue = 34
age.myValue

first.myValue
nick.myValue
