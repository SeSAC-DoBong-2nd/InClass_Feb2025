//
//  SimpleTableViewController.swift
//  SeSACRxThreads
//
//  Created by 박신영 on 2/26/25.
//

import UIKit

import SnapKit

final class SimpleTableViewController: UIViewController {
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }

    func setTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
    }
    

    
}

extension SimpleTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell")!
        
        var content = cell.defaultContentConfiguration()
        content.text = "케케몬 \(indexPath.row)"
        content.secondaryText = "두번 째 텍스트"
        content.image = UIImage(systemName: "star")
        content.textProperties.color = .systemGreen
        content.textProperties.font = .boldSystemFont(ofSize: 20)
        content.imageProperties.tintColor = .systemPink
        content.imageToTextPadding = 100
        
        cell.contentConfiguration = content
        
        return cell
    }
    
}
