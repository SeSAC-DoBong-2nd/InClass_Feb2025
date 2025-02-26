//
//  SimpleCollectionViewController.swift
//  SeSACRxThreads
//
//  Created by 박신영 on 2/26/25.
//

/*
 *Data
 진화 전
 -> Delegate, DataSource : (인덱스 기반 조회) ex) list[indexPath.row]
 
 진화 후
 -> Delegate, DiffableDataSource : (데이터 기반 조회)
 
 *Layout
 -> FlowLayout
 -> List Configuration
 
 *Presentation
 진화 전
 -> CellForRowat = dequeueReusableCell
 진화 후
 -> List cell = dequeueConfiguredReusableCell
 */

import UIKit

import SnapKit

//Identifiable: 해당 구조체에서 'id'라는 변수가 필요하다. 이를 고유한 id 값으로 활용한다. 라는 뜻의 프로토콜
struct Product: Hashable, Identifiable {
    let id = UUID() //이를 만들어둬 혹시라도 같은 값이 중복되어 Hashable을 해치는 순간을 미연에 방지한다.
    let name: String
    let price = 400000//Int.random(in: 1...10000) * 1000
    let count = 8//Int.random(in: 1...10)
}


final class SimpleCollectionViewController: UIViewController {
    
    //해당 enum이 하나의 class 안에서만 활용된다면, 그 class 안에 그냥 넣어버리자. 그래야 최적화 굳
    enum Section: CaseIterable {
        case main
        case sub
    }

    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    //collectionView.register 코드 대신
    //CellRegistration의 Item에 어떠한 타입이 들어가는지 잘 봐야함
//    var registration: UICollectionView.CellRegistration<UICollectionViewListCell, Product>!
        //diffable 쓰면 컬렉션 뷰 datasource 가 없으니 그냥 함수 안으로 옮김
    
    //<섹션을 구분해줄 데이터 타입, 셀에 들어가는 데이터 타입>
    //Diffable 사용 시: numberOfItemsInSection, cellforItemAt 사용하지 않아도 됨
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
        //Product Confirm to Hashable
        //셀에 들어갈 타입에 Product를 넣으니 Product에 Hashable을 채택해야함
    
    var list = [
        Product(name: "MackBook Pro M5"),
        Product(name: "MackBook Pro M5"),
        Product(name: "트랙패드"),
        Product(name: "금")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.delegate = self
//        collectionView.dataSource = self
        configureDataSource()
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        //첫번째 제네릭 = 섹션타입
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections(Section.allCases)
        //해당 sections에 들어가는 숫자들은 index의 개념이 아닌, 섹션 고유의 값이라 생각하면 된다. 그렇기에 중복 값이 있으면 안됨.
            //고유하다 == Hashable
        //즉, 100, 1, 2 인 상황에 0번째 섹션은 100이라는 고유의 섹션 identifier를 가진 곳이기에 toSection의 값이 100인 값들이 0번째 섹션에 추가된다.
            //위처럼 고유해야하는 값을 사람이 int나 string으로 규정하면 오타와 같은 휴먼에러가 발생할 수 있으니 중복된 case를 적지못하는 enum을 활용한다.
        snapshot.appendItems([Product(name: "ja123ck")], toSection: .sub)
        snapshot.appendItems(list, toSection: .main)
        snapshot.appendItems([Product(name: "ka214ck")], toSection: .sub)
        dataSource.apply(snapshot)
    }
    
    //Flow -> Compositional -> List - Configuration
        // 테이블 시스템 기능을 컬렉션뷰로도 만들 수 있도록 함
    func createLayout() -> UICollectionViewLayout {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .systemGreen
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        
        return layout
    }
    
    private func configureDataSource() {
            //diffable 쓰면 컬렉션 뷰 datasource 가 없으니 그냥 함수 안으로 옮김
        //cellForItemAt 내부 코드
        //+@ 클로저 속 매개변수가 하나라면 생략 가능. 따라서, handler 매개변수 생략
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, Product> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.name
            content.textProperties.color = .brown
            content.textProperties.font = .boldSystemFont(ofSize: 20)
            
            content.secondaryText = itemIdentifier.price.formatted() + "원"
            content.secondaryTextProperties.color = .blue
            
            content.image = UIImage(systemName: "pencil")
            content.imageProperties.tintColor = .orange
            
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
            
            backgroundConfig.backgroundColor = .yellow
//            backgroundConfig.cornerRadius = 8 //아래 strokeWidth가 inset으로 들어가는거라 양 모서리의 stroke가 깎여 보임
            backgroundConfig.strokeColor = .systemRed
            backgroundConfig.strokeWidth = 1
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            //cellForItemAt 과 같은 영역
            
            //Q. list[indexPath.item] 이걸 안 쓰면 해당 모델의 값을 어찌알지?
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
}

extension SimpleCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let data = list[indexPath.item] //이와 같이 differable에서 값에 접근하는 방식으로 쓰면 어색하다. 왜냐하면 인덱스 기반이기 때문
        
        let data = dataSource.itemIdentifier(for: indexPath) //이와 같이 접근해야 데이터 기반 이기에 옳다.
        
        
//        list.remove(at: indexPath.item)
        
//        let product = Product(name: "고래밥 \(Int.random(in: 1...100))")
//        list.insert(product, at: 2)
//        updateSnapshot()
        //updateSnapshot 내의 apply가 바뀐 Snapshot과 기존의 data Snapshot을 비교하여 차이있는 것만 바뀌도록 한다.
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return list.count
//    }
    
    /*
     원래 컬렉션뷰 = dequeueReusableCell
     - customCell + identifier + register 로 구성
     
     변화된 컬렉션뷰 = dequeueConfiguredReusableCell
     - systemCell +     X      + CellRegistration
     */
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        //이전 사용 방법
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: <#T##String#>, for: <#T##IndexPath#>) as! 'CustomCell'
//        
//        let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: list[indexPath.item])
//        
//        
//        return cell
//    }
    
}
