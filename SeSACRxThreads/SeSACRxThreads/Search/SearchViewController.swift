//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 8/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var items = BehaviorRelay(value: data)
    var data = ["First Item",
                "Second Item",
                "Third Item",
                "AAA", "213123", "warasf", "'asdasda'", "214rs", "ew525",
                "C",
                "B",
                "AB",
                "BCA"]
    
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
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
    }
    
    func bind() {
        items
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: SearchTableViewCell.identifier,
                    cellType: SearchTableViewCell.self)
            ) {row, element, cell in
                cell.appNameLabel.text = element
                cell.appIconImageView.backgroundColor = .lightGray
                
                //셀 구독 중첩
                cell.downloadButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.navigationController?.pushViewController(DetailViewController(), animated: true)
                    }.disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
        //서치바 + 엔터 + append
        searchBar.rx.searchButtonClicked //searchButtonClicked 이거 text가 공백("")이면 동작안함, 아래 orEmpty는 다 동작
//            .withLatestFrom(searchBar.rx.text.orEmpty, resultSelector: { _, searchBarText in
//                return "\(searchBarText) 라고 입력했습니다."
//            })
            .withLatestFrom(searchBar.rx.text.orEmpty) //위 처럼 가공하지 않고 첫번째 매개변수를 그대로 내보낸다면 이와 같이 두번째 매개변수를 생략할 수 있다.
            .bind(with: self) { owner, searchBarText in
                print("search tap: \(owner.searchBar.text ?? "") \(searchBarText)")
                owner.data.insert(searchBarText, at: 0)
                owner.items.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        
        //실시간 검색
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance) //1초 뒤 통신한 것을 보여줌
            .distinctUntilChanged() //동일한 글자라면 무시
            .bind(with: self) { owner, text in
                print("text: \(text)")
                //빈문자열인 경우 전체데이터, 그게 아니라면 text를 포함하는 데이터를 테이블뷰에 출력해보기
                
                //q데이터가 100만개, 혹은 실시간 서버 통신
                let result = text == ""
                ?  owner.data : owner.data.filter { $0.uppercased().contains(text.uppercased()) }
                owner.items.accept(result)
            }
            .disposed(by: disposeBag)
    }
    
    func beforeInOutRefactorBind() {
        print(#function)
        
        //서치바 리턴 클릭.
        //        searchBar.rx.searchButtonClicked
        //            .throttle(.seconds(1), scheduler: MainScheduler.instance) //1초 동안 멈추게 함
        //            .withLatestFrom(searchBar.rx.text.orEmpty) //현재 searchbar.text 글자 가져오기
        //            .distinctUntilChanged() //중복글자 동작 방지
        //            .bind(with: self) { owner, _ in
        //                print("리턴키 클릭")
        //            }
        //            .disposed(by: disposeBag)
        
        //실시간 검색
        searchBar.rx.text.orEmpty
            .throttle(.seconds(1), scheduler: MainScheduler.instance) //1초 동안 멈추게 함
            .withLatestFrom(searchBar.rx.text.orEmpty) //현재 searchbar.text 글자 가져오기
            .distinctUntilChanged() //중복글자 동작 방지
            .bind(with: self) { owner, _ in
                print("리턴키 클릭")
            }
            .disposed(by: disposeBag)
        
        items
            .bind(to: tableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as! SearchTableViewCell
                cell.appNameLabel.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        //        //index 알려줌
        //        tableView.rx.itemSelected //옵저버블
        //            .bind(with: self) { owner, index in
        //                print(index, "!!!")
        //            }
        //            .disposed(by: disposeBag)
        //
        //        //index Selected 눌러 model 데이터 가져옴
        //        tableView.rx.modelSelected(String.self) //옵저버블
        //            .bind(with: self) { owner, value in
        //                print(value)
        //            }
        //            .disposed(by: disposeBag)
        
        //2개 이상의 옵저버블을 하나로 합쳐줌: 방법 1
        //        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
        //            .map {
        //                "\($0.0.row) 번째 인덱스에는 \($0.1) 데이터가 있습니다."
        //            }
        //            .bind(with: self) { owner, value in
        //                print(value)
        //            }
        //            .disposed(by: disposeBag)
        
        //2개 이상의 옵저버블을 하나로 합쳐줌: 방법 2
        //그러나 combineLatest 은 지맘대로 움직임 datasource 다룰 때에는 zip을 활용함
        Observable.combineLatest(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .map {
                "\($0.0.row) 번째 인덱스에는 \($0.1) 데이터가 있습니다."
            }
            .bind(with: self) { owner, value in
                print(value)
            }
            .disposed(by: disposeBag)
    }
    
    func test() {
        let mentor = Observable.of("hue", "jack", "bran", "den")
        let age = Observable.of(1, 2, 3)
        
        //zip:
        //  안에 포함된 것들의 최소 짝 갯수에 맞춰 활용된다.
        //  즉, 짝이 맞아야 이벤트를 방출한다.
        Observable.zip(mentor, age)
            .bind(with: self) { owner, value in
                print(value.0, value.1)
            }
            .disposed(by: disposeBag)
        
        //combineLatest
        //
        Observable.combineLatest(mentor, age)
            .bind(with: self) { owner, value in
                print(value.0, value.1)
            }
            .disposed(by: disposeBag)
    }
    
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
        print("추가 버튼 클릭")
    }
    
    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
}
