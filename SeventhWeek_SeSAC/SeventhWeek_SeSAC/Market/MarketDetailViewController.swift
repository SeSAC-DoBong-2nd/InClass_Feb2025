//
//  MarketDetailViewController.swift
//  SeventhWeek_SeSAC
//
//  Created by 박신영 on 2/6/25.
//

import UIKit

class MarketDetailViewController: UIViewController {
    
    let viewModel = MarketDetailViewModel()
    
    init() {
        print("MarketDetailViewController init")
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    
    deinit {
        print("MarketDetailViewController",#function)
    }
    //viewDidDisappear != Deinit
    //self <<<
    //weak self?
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("MarketDetailViewController",#function)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindData()
    }
    
    private func bindData() {
        viewModel.outputOneMarket.bind { [weak self] title in
            guard let self,
                  let title else {return}
            self.navigationItem.title = title
        }
    }
    
    
}

extension MarketDetailViewController {
    
    private func configureView() {
        view.backgroundColor = .lightGray
    }
    
}
