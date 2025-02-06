//
//  MarketViewController.swift
//  SeSACSevenWeek_2
//
//  Created by Jack on 2/6/25.
//

import UIKit
import SnapKit

final class MarketViewController: UIViewController {
  
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "MarketCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
      
    private let viewModel = MarketViewModel()

    deinit {
        print("MarketViewController Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureConstraints()
        bindData()
    }
    
    //VM에서 VC로 바인딩해줄 데이터.
    //뷰모델에서 받아와서 뷰에 실시간 업데이트.
    private func bindData() {
        //vc의 viewDidLoad -> vm
        viewModel.inputViewDidLoadTrigger.value = ()
        
        viewModel.outputMarket.lazyBind { _ in
            self.tableView.reloadData()
        }
        
        //navigationItem.title이 String? 타입이기에 lazy가 아닌 그냥 bind를 써도 초깃값 nil이 들어가는 것이기에 앱이 꺼지지않음.
        viewModel.outputTitle.lazyBind { title in
            self.navigationItem.title = title
        }
        
        //bind와 lazyBind의 쓰임을 유의해서 쓰자.
        //아래와 같은 경우 vc의 이동인데 bind로 사용했다면 바로 이동하는 상황을 초래한다.
        viewModel.outputCellSelected.bind { data in
            print("outputCellSelected Bind")
            
            //nil처리를 했는데도 화면 전환이 되는 이유는?
              //현재 아래와 같은 방법으로 outputCellSelected.bind 함수가 바로 실행되었을 때 초깃값 nil을. 분기처리하였는데, inputCellSelected bind가 보다 먼저 실행되면서 Void가 들어와 nil값이 아니게 되었다. 그렇기에 아래 else 문으로 타지 않은 것이니, inputCellSelected의 함수를 lazyBind로 선언해주자.
            guard data != nil else {
                print("nil이라 화면 전환 되면 안됨")
                return
            }
            
            //detailVC title에 koreanName 값 전달 해보기
            let vc = MarketDetailViewController()
            vc.viewModel.outputOneMarket.value = data?.korean_name
            self.navigationController?.pushViewController(vc, animated: true)
            
            //내가 한 것.
//            let vc = MarketDetailViewController()
//            guard let index = self.viewModel.inputIndex.value else {return}
//            vc.title = self.viewModel.outputMarket.value[index].korean_name
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension MarketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputMarket.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketCell", for: indexPath)
        let data = viewModel.outputMarket.value[indexPath.row]
        cell.textLabel?.text = "\(data.korean_name) | \(data.english_name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
//        viewModel.inputIndex.value = indexPath.row
        viewModel.inputCellSelected.value = viewModel.outputMarket.value[indexPath.row]
    }
    
}

extension MarketViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
    
}

extension MarketViewController {
    
    private func configureView() {
        navigationItem.title = "마켓 목록"
        view.backgroundColor = .white
        view.addSubview(tableView)
    }

    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
