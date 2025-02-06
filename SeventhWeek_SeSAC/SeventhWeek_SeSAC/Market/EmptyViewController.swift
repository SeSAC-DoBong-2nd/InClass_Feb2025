//
//  EmptyViewController.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/6/25.
//

import UIKit

class EmptyViewModel {
    
    init() {
        print("EmptyViewModel",#function)
    }
    
    deinit {
        print("EmptyViewModel",#function)
    }
    
}

class EmptyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown
        print("EmptyViewController",#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("EmptyViewController",#function)
    }
    
    init() {
        print("EmptyViewController init")
        
        super.init(nibName: nil, bundle: nil)
    }
    let viewModel = EmptyViewModel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("EmptyViewController deinit")
    }

}
