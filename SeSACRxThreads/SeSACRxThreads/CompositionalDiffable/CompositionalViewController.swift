//
//  CompositionalViewController.swift
//  SeSACRxThreads
//
//  Created by 박신영 on 2/27/25.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

/*
 1. 값 중복: Hashable 하지 않을 떄
    - 하나의 컬렉션 뷰에서 어느 곳에서든 겹치는 데이터가 나오면 안된다.
 */

final class CompositionalViewController: UIViewController {
    
    enum Section: CaseIterable {
        case First
        case Second
    }
    private let disposeBag = DisposeBag()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    
    var list = [
        1, 2, 3, 4, 54, 656, 124125, 542, 245346, 123123, 33333, 332, 12521, 124235, 124432, 223, 423
    ]
    var list2 = [5, 6, 7, 8, 9, 35, 24, 231, 2435, 124152, 12332513, 12, 13, 14, 15, 16, 189, 12512 ,121225, 21412, 2421, 241]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureDataSource()
        updateSnapshot()
        multiUnicast()
    }
    
    //Observable(unicast
        //unicast: 이는 개별적으로 스트림이 생성 되는 것
        //구독 간 스트림이 공유되지 않는다.
    
    //Subject(multicast)
        //multicast: 이는 단일 스트림을 여러 구독자에게 공유하는 것
        //모든 구독이 동일한 스트림을 받음.
        //옵저버블에 share를 적용한 것과 동일한 효과
    private func multiUnicast() {
//        let sampleInt = Observable<Int>.create { observer in
//            observer.onNext(Int.random(in: 1...100))
//            return Disposables.create()
//        }
        
        //구독이 발생하지 않아도 이벤트를 방출할 수 있다 = HotObservable
        //subject는 구독 시점과 상관없이 이벤트를 방출할 수 있다.
            //단,subscribe 이전 이벤트를 보내도 전달은 안된다. 그러나 이벤트를 보낼 수는 있는 것.
        //데이터 스트림을 중간부터 확인하게 될 수도 있다.
//        let sampleInt = BehaviorSubject(value: 0)
        let sampleInt = PublishSubject<Int>()
        sampleInt.onNext(Int.random(in: 1...100))
        
        sampleInt //전달
            .subscribe { value in
                print("1: \(value)")
            }.disposed(by: disposeBag)
        
        sampleInt //전달
            .subscribe { value in
                print("2: \(value)")
            }.disposed(by: disposeBag)
        
        sampleInt //전달
            .subscribe { value in
                print("3: \(value)")
            }.disposed(by: disposeBag)
        
        
        //구독이 발생할 때까지 기다렸다가 이벤트를 방출 = ColdObservable
        //ex) just, from, on
        //처음부터 모든 데이터 스트림을 확인할 수 있다.
        let just = Observable.just([1, 3, 8]) //이렇게 생성되어 있더라도 아무짓도 안하지만
        
        just.subscribe { <#[Int]#> in //구독이 되는 순간부터 이벤트를 방출할 수 있는 것.
            <#code#>
        }
            
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections(Section.allCases)
        //appendItems 순서 중요. 이에 따라 섹션간 중복데이터는 후자에 적힌 섹션으로 데이터 이동
        snapshot.appendItems(list, toSection: .First)
        snapshot.appendItems(list2, toSection: .Second)
        
        //snapshot.appendItems(list, toSection: .Second)
            //위와 같이 사용하면 섹션마다도 달라야하는 값들이기에 Hashable 하지 않아서 제일 후반에 나오는 섹션으로 아이템을 그냥 옮겨버림
        dataSource.apply(snapshot)
    }
    
    private func configureDataSource() {
        //cell register
        let cellRegistration = UICollectionView.CellRegistration<CompositionalCollectionViewCell, Int> { cell, indexPath, itemIdentifier in
            print("cellRegistration", indexPath)
            cell.label.text = "\(indexPath)"
        }
        
        //cellForItemAt
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            print("ResusableCell", indexPath)
            print(itemIdentifier)
            
            return cell
        })
    }
    
    //여러 섹션 다루기
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
                let innerGroup =  NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitems: [item])
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [innerGroup])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            }
        }
        return layout
    }
    
    //외부 그룹, 내부 그룹 활용
//    private func createLayout() -> UICollectionViewLayout {
//        
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3))
//
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//        
//        let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
//        let innerGroup =  NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitems: [item])
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(100))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [innerGroup])
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPaging
//        
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        
//        return layout
//    }
    
    //컴포지셔널 레이아웃 step 2
//    private func createLayout() -> UICollectionViewLayout {
//        
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(100))
//    
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPagingCentered
//        /*
//         1. paging = 디바이스 넓이 기준으로 그만큼 넘어감
//         2. groupPaging = group의 넓이 만큼 넘어감
//         3. groupPagingCentered = groupPaging이 되되, cell이 가운데를 기준으로 됨
//         */
//        
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        
//        return layout
//    }
    
    //컴포지셔널 레이아웃 step 1
//    private func createLayout() -> UICollectionViewLayout {
//        
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
//        
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
//    
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        
//        let section = NSCollectionLayoutSection(group: group)
////        section.interGroupSpacing = 20
//        
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        
//        return layout
//    }
    
//    private func createLayout() -> UICollectionViewLayout {
//        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        configuration.backgroundColor = .purple
//        configuration.showsSeparators = true
//        
//        //특정 cell 스와이프 시 동작 부여
////        configuration.leadingSwipeActionsConfigurationProvider
//        
//        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
//        
//        return layout
//    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}
