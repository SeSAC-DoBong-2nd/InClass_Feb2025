import Foundation

enum Key: String {
    case email
    case nickname
    case phone
}

UserDefaults.standard.set("a@a.com",
                          forKey: Key.email.rawValue)
UserDefaults.standard.set("고래밥",
                          forKey: Key.nickname.rawValue)
UserDefaults.standard.set("1234",
                          forKey: Key.phone.rawValue)

let email = UserDefaults.standard.string(forKey: Key.email.rawValue)
let nickname = UserDefaults.standard.string(forKey: Key.nickname.rawValue)
let phone = UserDefaults.standard.string(forKey: Key.phone.rawValue)

print(email, nickname, phone)
