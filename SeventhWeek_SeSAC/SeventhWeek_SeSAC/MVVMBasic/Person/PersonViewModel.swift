//
//  PersonViewModel.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/5/25.
//

import Foundation

struct Person {
    let name: String
    let age: Int
}

final class PersonViewModel {
    let navTitle = "Person List"
    let resetTitle = "리셋버튼"
    let loadTitle = "로드버튼"
    
    var inputloadButtonTapped: Observable<Void> = Observable(())
    
    //테이블 뷰에 보여줄 데이터
    var people: Observable<[Person]> = Observable([])
    
    init() {
        inputloadButtonTapped.lazyBind { _ in
            self.people.value = self.generateRandomPeople()
        }
    }
    
    private func generateRandomPeople() -> [Person] {
        return [
            Person(name: "James", age: Int.random(in: 20...70)),
            Person(name: "Mary", age: Int.random(in: 20...70)),
            Person(name: "John", age: Int.random(in: 20...70)),
            Person(name: "Patricia", age: Int.random(in: 20...70)),
            Person(name: "Robert", age: Int.random(in: 20...70))
        ]
    }
}
