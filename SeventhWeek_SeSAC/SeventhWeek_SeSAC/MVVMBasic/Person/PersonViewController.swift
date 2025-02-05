//
//  PersonViewController.swift
//  SeSACSevenWeek
//
//  Created by Jack on 2/5/25.
//

import UIKit

import SnapKit

class PersonViewController: UIViewController {
    // MARK: - Properties
    private var viewModel = PersonViewModel()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 60
        table.register(UITableViewCell.self, forCellReuseIdentifier: "PersonCell")
        return table
    }()
    
    private let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loadButton, resetButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTableView()
        setupActions()
        
        navigationItem.title = viewModel.navTitle
        loadButton.setTitle(viewModel.loadTitle, for: .normal)
        resetButton.setTitle(viewModel.resetTitle, for: .normal)
        
        viewModel.people.bind { value in
            self.tableView.reloadData()
        }
    }
     
    private func setupUI() {
        view.backgroundColor = .white
        
        [buttonStackView, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupActions() {
        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func loadButtonTapped() {
        //버튼을 클릭했다는 사실만 뷰모델에 알려주기.
        viewModel.inputloadButtonTapped.value = ()
    }
    
    @objc private func resetButtonTapped() {
        viewModel.people.value.removeAll()
        tableView.reloadData()
    }
    
    
}
 
extension PersonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.people.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        let person = viewModel.people.value[indexPath.row]
        cell.textLabel?.text = "\(person.name), \(person.age)세"
        return cell
    }
}
