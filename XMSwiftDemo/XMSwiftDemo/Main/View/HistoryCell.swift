//
//  HistoryCell.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/22.
//  Copyright © 2020 李学敏. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    lazy var timeLabel :UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    lazy var contentLabel :UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(15)
            make.width.equalTo(screenWidth - 30)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 45, left: 15, bottom: 15, right: 15))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
