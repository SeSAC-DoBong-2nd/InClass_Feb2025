//
//  CompositionalCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by 박신영 on 2/27/25.
//

import UIKit

import SnapKit

final class CompositionalCollectionViewCell: UICollectionViewCell {
    
    let label = {
        let view = UILabel()
        view.backgroundColor = .yellow
        view.textColor = .brown
        view.font = .boldSystemFont(ofSize: 20)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        contentView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
