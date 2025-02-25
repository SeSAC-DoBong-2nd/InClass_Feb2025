//
//  MultiSectionViewController.swift
//  SeSACRxThreads
//
//  Created by 박신영 on 2/25/25.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

//SectionModelType
// SectionModelType에서 어떤게 sectiontitle이고 item인지 알 수 없으니 알 수 있도록 규정화하는 Item을 사용해라.
struct Mentor {
    //섹션 정보
    var name: String //섹션 타이틀 ex) Jack, Den, Bran ...
    var items: [Item] //섹션 속 cell에 들어갈 정보
}

struct Ment {
    let word: String
    let count = Int.random(in: 1...1000)
}

extension Mentor: SectionModelType {
    typealias Item = Ment
    
    init(original: Mentor, items: [Item]) {
        self = original
        self.items = items
    }
}



final class MultiSectionViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        //RxTableViewSectionedReloadDataSource 클로저 매개변수
        //1 - TableViewSectionedDataSource<SectionModelType>
        //4 - SectionModelType.Item
        let dataSource = RxTableViewSectionedReloadDataSource<Mentor> { dataSource, tableView, indexPath, item  in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell", for: indexPath)
            cell.textLabel?.text = "\(item.word): \(item.count)번"
            
            return cell
        } titleForHeaderInSection: { dataSource, index in
            //sectionModels == 위 dataSource가 되는 해당 모델에 접근
            return dataSource.sectionModels[index].name
        }
        
        let mentor = [
            Mentor(name: "Jack", items: [
                Ment(word: "맛점하셨나요?"),
                Ment(word: "맛점하셨나요?"),
                Ment(word: "맛점하셨나요?")
            ]),
            Mentor(name: "Den", items: [
                Ment(word: "정답은 없죠"),
                Ment(word: "화이팅!"),
            ]),
            Mentor(name: "Bran", items: [
                Ment(word: "잘 되시나요")
            ])
        ]
        
        Observable.just(mentor)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sectionCell")
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
