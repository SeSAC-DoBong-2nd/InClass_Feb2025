import Foundation

// 숫자 세자리 마다 , 찍기

@propertyWrapper
struct Decimal {
    var money: String
    
    var projectedValue = ""
    var wrappedValue: String {
        get {
            return Int(money)!.formatted(.number) + "원"
        }
        set {
            money = newValue
            projectedValue = "당신이 이체한 금액은 \(newValue)입니다."
        }
    }
    
}

struct Example {
    @Decimal(money: "7000")
    var number
}

var example = Example()

example.number
example.number = "592571047108"
example.$number
