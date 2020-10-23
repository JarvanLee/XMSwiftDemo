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
            var model = CacheModel.init(timestamp: curTime)
            
            if let tmpData = data{
                if let json = String(data: tmpData, encoding: String.Encoding.utf8){
                    model.res_code = 0
                    model.res_msg = "成功"
                    model.content = json
                    
                    NotificationCenter.default.post(name: Notification.Name.githubResponse, object: model, userInfo: nil)
                }else{
                    model.res_code = -2
                    model.res_msg = "JSON解析失败"
                }
            }else{
                var tmpError = error as NSError?
                if tmpError == nil{
                    tmpError = NSError(domain: "com.liran.LXMDemo", code: -1,userInfo: [NSLocalizedDescriptionKey: "未知错误"])
                }
                model.res_code = tmpError!.code
                model.res_msg = tmpError!.localizedDescription
            }
            
            //以时间为文件名缓存请求结果
            ArchiveManager.saveResponseModel(model, urlString: urlStr)
            
            return
        }.resume()
    }
}
