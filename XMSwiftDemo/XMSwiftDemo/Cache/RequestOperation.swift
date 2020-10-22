//
//  RequestOperation.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/22.
//  Copyright © 2020 李学敏. All rights reserved.
//

import UIKit

struct CacheModel:Codable{
    var timestamp:String
    var content:String
    init(timestamp: String, content: String) {
        self.timestamp = timestamp
        self.content = content
    }
}

class RequestHistoryModel:Codable {
    var timestamps:[String] = []
}

class RequestOperation: Operation {
    var urlString:String?
    
    required init(urlString:String) {
        self.urlString = urlString
    }
    
    override func main() {
        if isCancelled {return}
        guard let urlStr = urlString ,let url = URL(string: urlStr) else { return }
        
        let curTime = Date().milliStamp
        var request = URLRequest(url: url)
        request.timeoutInterval = 30
        //保存请求记录
        ArchiveManager.saveRequestHistory(timestamp: curTime, urlString: urlStr)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let tmpData = data,let json = String(data: tmpData, encoding: String.Encoding.utf8){
                let cacheModel = CacheModel(timestamp: curTime, content: json)
                //以时间为文件名缓存请求结果
                ArchiveManager.saveResponseModel(cacheModel, urlString: urlStr)
                NotificationCenter.default.post(name: Notification.Name.githubResponse, object: cacheModel, userInfo: nil)
            }
            return
        }.resume()
    }
}
