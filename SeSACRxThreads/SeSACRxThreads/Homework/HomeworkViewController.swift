//
//  HomeworkViewController.swift
//  RxSwift
//
//  Created by Jack on 1/30/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    let profileImage: String
}

class HomeworkViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = HomeworkViewModel()
    
    let items = BehaviorRelay(value: ["Test님"]) //테이블뷰 데이터소스
    let recent = BehaviorRelay(value: ["Test님"]) //컬렉션뷰 데이터소스
    
    let tableView = UITableView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
     
    private func bind() {
        let recentText = PublishSubject<String>()
        
        let input = HomeworkViewModel.Input(
            searchButtonTap: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty, recentText: recentText
        )
        
        let output = viewModel.transform(input: input)
        
//        searchBar.rx.searchButtonClicked
//            .withLatestFrom(searchBar.rx.text.orEmpty)
//            .map { "\($0)님" }
//            .asDriver(onErrorJustReturn: "손님")
//            .drive(with: self) { owner, value in
//                print("value: \(value)")
//                var data = owner.items.value
//                data.insert(value, at: 0)
//                owner.items.accept(data)
//            }.disposed(by: disposeBag)
        
        output.items
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: PersonTableViewCell.identifier,
                cellType: PersonTableViewCell.self
            )) { row, element, cell in
                cell.usernameLabel.text = element
            }.disposed(by: disposeBag)
        
        output.recent
            .drive(
                collectionView.rx.items(cellIdentifier: UserCollectionViewCell.identifier,
                                        cellType: UserCollectionViewCell.self)
            ) { row, element, cell in
                cell.label.text = element
            }.disposed(by: disposeBag)
        
        Observable.zip(
            tableView.rx.modelSelected(String.self),
            tableView.rx.itemSelected
        )
        .map { $0.0 }
        .bind(with: self) { owner, value in
//            input.recentText = value
            recentText.onNext(value)
//            var data = owner.recent.value
//            data.append(value)
//            owner.recent.accept(data)
        }.disposed(by: disposeBag)
        
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
         
        collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        collectionView.backgroundColor = .lightGray
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }

}
 
