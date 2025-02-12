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



//age.myValue
//age.myValue = 34
//age.myValue
//
//first.myValue
//nick.myValue


enum UserDefaultsManager {
    
    enum Key: String {
        case age, first, nick
    }
    
    static var age = JackDefaults(key: Key.age.rawValue, empty: 16)
    static var first = JackDefaults(key: Key.first.rawValue, empty: false)
    static var nick = JackDefaults(key: Key.nick.rawValue, empty: "고래밥")
    
}

//vc
//enum, strct 구조에서 항상 myValue를 호출해야 하는 부분이 아쉬움!!
UserDefaultsManager.age.myValue
UserDefaultsManager.age.myValue = 89
UserDefaultsManager.age.myValue


//원하는 것?!
UserDefaultsManager.age // 이처럼 쓰면 89가 자동으로 나오도록
