//원하는 것?!
UserDefaultsManager.age
// 이처럼 쓰면 UserDefaultsManager.age.myValue가 나오도록
// => @propertyWrapper 사용!

import Foundation

/*
 @propertyWrapper
 - wrappedValue 가 반드시 있어야함.
  => 왜냐하면 반드시 한가지로 wrapper 돼야하기 때문
 - projectedValue (option)
  => wrappedValue을 활용한 다른 값을 쓰고자 할 때 옵션으로 사용
 
 
 번외
 - defaultValue //이건 아래 empty와 같이 그냥 초깃값을 뜻함.
 */

enum UserDefaultsManager {
    
    @propertyWrapper struct JackDefaults<T> {
        let key: String
        let empty: T
        
        private(set) var projectedValue: Bool = false
        
        var wrappedValue: T {
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
    
    enum Key: String {
        case age, first, nick
    }
    
    @JackDefaults(key: Key.age.rawValue, empty: 16)
    static var age
    
    @JackDefaults(key: Key.first.rawValue, empty: false)
    static var first
    
    @JackDefaults(key: Key.nick.rawValue, empty: "고래밥")
    static var nick
    
}

UserDefaultsManager.age
UserDefaultsManager.age = 100
UserDefaultsManager.age

UserDefaultsManager.nick //wrappedValue
UserDefaultsManager.$nick //projectedValue: wrapper의 부가적인 상태를 외부에 보여주려고 할 때 사용


