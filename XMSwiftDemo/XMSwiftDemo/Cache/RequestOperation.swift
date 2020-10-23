//
//  RequestOperation.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/22.
//  Copyright © 2020 李学敏. All rights reserved.
//

import UIKit



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
        
        //开始抓取数据,现实开发中会用Alamofire,并封装Service类和Router/API类
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var cacheModel = CacheModel.init(timestamp: curTime)
            
            if let tmpData = data{
                if let json = String(data: tmpData, encoding: String.Encoding.utf8){
                    cacheModel.res_code = 0
                    cacheModel.res_msg = "成功"
                    cacheModel.content = json
                    
                    NotificationCenter.default.post(name: Notification.Name.githubResponse, object: cacheModel, userInfo: nil)
                }else{
                    cacheModel.res_code = -2
                    cacheModel.res_msg = "JSON解析失败"
                }
            }else{
                var tmpError = error as NSError?
                if tmpError == nil{
                    tmpError = NSError(domain: "com.liran.LXMDemo", code: -1,userInfo: [NSLocalizedDescriptionKey: "未知错误"])
                }
                cacheModel.res_code = tmpError!.code
                cacheModel.res_msg = tmpError!.localizedDescription
            }
            //以时间为文件名缓存请求结果
            ArchiveManager.saveResponseModel(cacheModel, urlString: urlStr)
            
            return
        }.resume()
    }
}
