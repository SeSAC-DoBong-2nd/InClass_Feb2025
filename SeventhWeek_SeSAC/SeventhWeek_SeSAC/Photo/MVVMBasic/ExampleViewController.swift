//
//  ExampleViewController.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/4/25.
//

import UIKit

final class ExampleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        configureView()
        test()
        test2()
    }
    
    func configureView() {
        view.backgroundColor = .white
    }
    
    func test() {
        var num = 3
        
        print(num)
        
        num = 6
        print(num)
        //이처럼 값이 바뀌었을 때 새로 출력을 찍어주지 않는 이상, num 값이 바뀌어도 출력되지 않음.
    }
    
    func test2() {
        var num = Observable(3)
        num.bind { value in
            print(value)
        }
        
        num.value = 2
        num.value = 100
    }


}
