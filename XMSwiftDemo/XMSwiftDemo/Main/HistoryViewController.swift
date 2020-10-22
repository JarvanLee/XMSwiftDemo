//
//  HistoryViewController.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/21.
//  Copyright © 2020 李学敏. All rights reserved.
//

import UIKit
import MJRefresh

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

class HistoryViewController: UIViewController {

    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier:HistoryCell.description())
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var dataSource:RequestHistoryModel = RequestHistoryModel()
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        prepareForUI()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.githubResponse, object: nil, queue: OperationQueue.main) {  [weak self] notification in
            guard let `self` = self else { return }
            self.view.makeToast("有新的数据缓存了")
        }
    }
    
     func prepareForUI() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let header = MJRefreshNormalHeader.init {[weak self] in
            guard let `self` = self else {return}
            self.refreshDatasource()
        }
        header.stateLabel?.isHidden = true
        tableView.mj_header = header

        refreshDatasource()
    }
    
    fileprivate func refreshDatasource(){
        DispatchQueue.global().async {
            if let model = ArchiveManager.fetchRequestHistory(urlString: githubAPI){
                self.dataSource = model
            }
            DispatchQueue.main.async {
                self.tableView.mj_header?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}

extension HistoryViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.timestamps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let time = dataSource.timestamps[indexPath.row]
        let cell :HistoryCell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.description()) as! HistoryCell
        cell.timeLabel.text = DateFormatterInstance.shared.displayTimeString(Double(time))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let time = dataSource.timestamps[indexPath.row]
        CacheManager.shared.getContent(urlString: githubAPI, timestamp: time) { (content) in
            var detail = ""
            if let json = content{
                detail = """
                            \((DateFormatterInstance.shared.displayTimeString(Double(time)) ?? ""))
                            \(json)
                          """

            }
            DispatchQueue.main.async {
                if let cell = cell as? HistoryCell{
                    cell.contentLabel.text = detail
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
