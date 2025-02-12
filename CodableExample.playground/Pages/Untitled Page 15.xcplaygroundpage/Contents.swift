import Foundation

extension String {
    subscript(idx: Int) -> String? {
        guard (0..<count).contains(idx) else {
            return nil
        }
        let result = index(startIndex, offsetBy: idx)
        return String(self[result])
    }
}

// [ ] 대괄호를 통해 index에 접근하는 문법: subscript 문법
let list = ["7", "fg", "asd"]
list[2] //"asd"

let nick = "안녕하세요 반갑습니다"
nick[2] //"하"


struct UserPhoneList {
    var contacts = [
        "01022123123",
        "01022124345",
        "01054756756",
        "01067744688",
    ]
    //...
    subscript(idx: Int) -> String {
        get {
            return self.contacts[idx]
        } set {
            self.contacts[idx] = newValue
        }
    }
}

var phone = UserPhoneList()
phone[0] //== phone.contacts[0]이 되도록 하자.
phone[0] = "456"
phone[0]
