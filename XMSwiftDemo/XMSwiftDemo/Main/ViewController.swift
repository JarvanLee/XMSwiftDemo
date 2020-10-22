//
//  ViewController.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/21.
//  Copyright © 2020 李学敏. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var dataSource:CacheModel?{
        didSet{
            if let model = self.dataSource{
                self.timeLable.text = DateFormatterInstance.shared.displayTimeString(Double(model.timestamp))
                self.textView.text = model.content
            }
        }
    }
    
    lazy var textView :UITextView = {
        let textView = UITextView.init()
        textView.textColor = .gray
        textView.isEditable = false
        return textView
    }()
    
    lazy var timeLable:UILabel  = {
        let label = UILabel.init()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        prepareForUI()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.githubResponse, object: nil, queue: OperationQueue.main) {  [weak self] notification in
            guard let `self` = self else { return }
            guard let model = notification.object as? CacheModel else { return }
            self.dataSource = model
        }
    }
    
    fileprivate func prepareForUI(){
        
        let button = UIButton(type: .custom)
        button.setTitle("历史记录", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(historyClick), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        view.addSubview(timeLable)
        timeLable.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(XnavigationBarHeight + 20)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(screenWidth)
        }
        
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(timeLable.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-50-XSafeAreaBottomHeight)
        }
        
        var array = ArchiveManager.getAllFileName(urlString: githubAPI)
        array?.sort()
        if let tmpArr = array,tmpArr.count > 0{
            self.dataSource = ArchiveManager.fetchResponseContent(timestamp: tmpArr.last ?? "", urlString: githubAPI)
        }
    }

    @objc func historyClick() {
        let vc = HistoryViewController.init()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

