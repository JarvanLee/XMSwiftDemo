//
//  HistoryViewController.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/21.
//  Copyright © 2020 李学敏. All rights reserved.
//

import UIKit
import MJRefresh

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
    var newestCache:CacheModel?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        prepareForUI()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.githubResponse, object: nil, queue: OperationQueue.main) {  [weak self] notification in
            guard let `self` = self else { return }
            guard let model = notification.object as? CacheModel else { return }
            self.newestCache = model
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
        guard let cell = cell as? HistoryCell else { return }
        if let model = newestCache,model.timestamp == time {
            cell.timeLabel.textColor = .green
            cell.contentLabel.textColor = .green
        }else{
            cell.timeLabel.textColor = .black
            cell.contentLabel.textColor = .gray
        }
        CacheManager.shared.getContent(urlString: githubAPI, timestamp: time) { (content) in
            var detail = ""
            if let json = content{
                detail = """
                            \((DateFormatterInstance.shared.displayTimeString(Double(time)) ?? ""))
                            \(json)
                          """

            }
            DispatchQueue.main.async {
                cell.contentLabel.text = detail
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
