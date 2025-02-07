import Foundation

//순환 참조

class Guild {
    
    var nickname: String
    unowned var owner: User?
    
    init(nickname: String) {
        self.nickname = nickname
        print("Guild Init")
    }
    
    //RC가 0이 됐을 때 deinit 호출
    deinit {
        print("Guild Deinit")
    }
    
}

class User {
    
    var nickname: String
    var guild: Guild?
    
    init(nickname: String) {
        self.nickname = nickname
        print("User Init")
    }
    
    //RC가 0이 됐을 때 deinit 호출
    deinit {
        print("User Deinit")
    }
    
}

//레퍼런스를 참조하는 게 증가한다면 reference count가 증가

var sesac: Guild? = Guild(nickname: "새싹") //Guild RC + 1
var character: User? = User(nickname: "미묘한도사") //User RC + 1

sesac?.owner = character //User RC + 1
character?.guild = sesac //Guild RC + 1

//---여기까지 Guild와 User 모두 RC 2개씩---

//character = nil //RC - 1
//sesac = nil //RC - 1
//그렇기에 nil을 실행해 각 -1씩 해주어도 deinit이 실행되지 않음

//아래와 같이 class안의 엮여있는 것들을 찾아 일일히 nil 처리하는 것은 현실적으로 불가능
//character?.guild = nil
//character = nil
//sesac = nil

//위 상황들을 방지하기 위한 대응법
// => weak, unowned 키워드로 해결 -> RC자체를 증가시키지 않도록 함.
// - 즉, 참조는 하고있으나, rc가 증가하지는 않음.
character = nil //RC - 1 (게임 계정 삭제 느낌)
