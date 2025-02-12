import Foundation

//오류 처리 패턴. 에러 핸들링
//if - else, switch - case
//do try - catch (*)


func checkDateFormat(text: String) -> Bool {
    let format = DateFormatter()
    format.dateFormat = "yyyyMMdd"
    
    return format.date(from: text) == nil ? false : true
}

//닉네임:
func validateUserInput(text: String) -> Bool {
    // 입력한 값이 비었는지
    guard !(text.isEmpty) else {
        print("빈값")
        return false
    }
    
    //입력한 값이 숫자인지 아닌지
    guard Int(text) != nil else {
        print("숫자가 아닙니다")
        return false
    }
    
    //입력한 값이 날짜형태로 변환이 되는 숫자인지 아닌지
    guard checkDateFormat(text: text) else {
        print("날짜 형태가 잘못되었습니다")
        return false
    }
    
    return true
}

//닉네임 완료 버튼을 누른 경우
if validateUserInput(text: "20240101") {
    print("가능")
} else {
    print("불가능")
}



//오류 처리 패턴 적용

//1. error에 대한 열거형 생성
  //컴파일러가 오류의 타입을 인정하게 됨
enum ValidationError: Error {
    //rawvalue string으로 설정해도, throw에서 string 값을 보낼 수 없음
    case emptyString
    case isNotInt
    case isNotDate
}

//에러를 발생시킬 수 있다는 것을 알리기 위해 throw 키워드를 함수 선언부의 파라미터 뒤에 붙임
//throwing function: throw 키워드로 표시된 함수
//Swift6에서는 throws(ValidationError) 와 같이 구체적인 error 타입을 명시하여 에러를 던져 catch문에서 as? 와 같이 타입캐스팅을 사용하지 않아도 된다.
func validateUserInputError(text: String) throws -> Bool {
    // 입력한 값이 비었는지
    guard !(text.isEmpty) else {
        print("빈값")
        throw ValidationError.emptyString
    }
    
    // 입력한 값이 숫자인지 아닌지
    guard Int(text) != nil else {
        print("숫자가 아닙니다")
        throw ValidationError.isNotInt
    }
    
    //입력한 값이 날짜형태로 변환이 되는 숫자인지 아닌지
    guard checkDateFormat(text: text) else {
        print("날짜 형태가 잘못되었습니다")
        throw ValidationError.isNotDate
    }
    
    return true
}

//let test = validateUserInput(text: "케케몬")

//이는 오류 대응을 할 수 없는 코드 (오류 발생시 앱이 종료됨)
//let result = try validateUserInputError(text: "")

//try?: 오류가 던져지면 nil로 반환. 그러나 어떤 오류가 발생했는지 알 수 없음
//let result = try? validateUserInputError(text: "")

//try!: 오류가 던져지면 런타임 오류 발생
//let result = try! validateUserInputError(text: "")


//위의 문제를 해결하는 do try - catch !!!
//ValidationError의 모든 case를 다루지 않더라도, switch의 default와 같이 그냥 catch 로 남은 case를 대응해도 된다.
do {
    try validateUserInputError(text: "케케몬")
} catch ValidationError.emptyString { //throw 이후 동작
    print("빈 값 입니다")
}
//catch ValidationError.isNotInt { //throw 이후 동작
//    print("no 숫자 입니다")
//}
catch ValidationError.isNotDate { //throw 이후 동작
    print("no Date 입니다")
} catch {
    print(error)
}


do {
    try validateUserInputError(text: "")
} catch {
    //swift5: Error 타입을 구체적으로 정의할 수 없어서 타입 캐스팅을 활용해서 처리
    switch error as? ValidationError {
    case .emptyString:
        print("빈 값 이지롱롱")
    default:
        print("나머지 오류처리")
    }
    
    //swift6: Error 타입에 대해 구체적인 정의 가능
    // => Typed Throws
    
}
