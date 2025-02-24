//
//  NewSearchViewController.swift
//  SeSACRxThreads
//
//  Created by 박신영 on 2/24/25.
//

import UIKit

import RxCocoa
import RxSwift

final class NewSearchViewController: UIViewController {
    
    private let viewModel = NewSearchViewModel()
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .lightGray
        view.rowHeight = 180
        view.separatorStyle = .none
        return view
    }()
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchController()
        configure()
        bind()
//        NetworkManager.shared.callBoxOffice(date: "20250222")
//            .subscribe(with: self) { owner, movie in
//                print("next", movie)
//            } onError: { owner, error in
//                print("error: \(error)")
//            } onCompleted: { owner in
//                print("onCompleted")
//            } onDisposed: { owner in
//                print("onDisposed")
//            }.disposed(by: disposeBag)

    }
    
    private func bind() {
        let input = NewSearchViewModel.Input(
            searchTap: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty
        )
        let output = viewModel.transform(input: input)
        
        output.list
            .bind(
                to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier,
                                       cellType: SearchTableViewCell.self)
            ) { row, element, cell in
                cell.appNameLabel.text = element.movieNm
            }
            .disposed(by: disposeBag)
        
        
        //flatMap, flatMapLatest
//        tableView.rx.itemSelected
//            .flatMapLatest { _ in
//                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug("timer")
//            }
//            .debug("cell")
//            .subscribe(with: self) { owner, value in
//                print(value)
//            }.disposed(by: disposeBag)
        
        //withLatestFrom 관련
//        tableView.rx.itemSelected
//            .withLatestFrom(Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance))
//            .subscribe(with: self) { owner, value in
//                print(value)
//            }.disposed(by: disposeBag)
        
        //map 관련
//        tableView.rx.itemSelected
//            .map { _ in
//                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//            }
//            .subscribe(with: self) { owner, value in
//                value.subscribe { number in
//                        print("number: \(number)")
//                    }.disposed(by: owner.disposeBag)
//            }.disposed(by: disposeBag)
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }
    
}
