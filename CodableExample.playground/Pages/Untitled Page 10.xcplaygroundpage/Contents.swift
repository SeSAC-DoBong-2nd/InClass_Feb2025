//# PropertyWrapper
//어차피 반복될거 하나도 합치면 안되나?!

//제네릭 미사용
import Foundation

struct JackDefaults {
    let key: String
    let empty: String
    var myValue: String {
        get {
            UserDefaults.standard.string(forKey: key) ?? empty
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

var nick = JackDefaults(key: "nick", empty: "손님")
var phone = JackDefaults(key: "phone", empty: "0")

nick.myValue
nick.myValue = "케케몬"
nick.myValue

phone.myValue
phone.myValue = "010-1234-5678"
phone.myValue


