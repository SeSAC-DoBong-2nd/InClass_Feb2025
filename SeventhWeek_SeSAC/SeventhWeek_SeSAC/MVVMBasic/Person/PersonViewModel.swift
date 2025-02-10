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
    
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        let inputloadButtonTapped: Observable<Void> = Observable(())
    }
    
    struct Output {
        //테이블 뷰에 보여줄 데이터
        let people: Observable<[Person]> = Observable([])
    }
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    private func transform() {
        input.inputloadButtonTapped.lazyBind { [weak self] _ in
            guard let self else {return}
            self.output.people.value = self.generateRandomPeople()
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
