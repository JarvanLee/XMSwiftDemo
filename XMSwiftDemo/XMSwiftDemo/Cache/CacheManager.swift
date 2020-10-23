//
//  CacheManager.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/22.
//  Copyright © 2020 李学敏. All rights reserved.
//

import UIKit

typealias CompletionHandle = ((_ content: String?) -> ())

class CacheManager: NSObject {

    static let shared = CacheManager()
    
    private var cache = NSCache<NSString,NSString>()
    
    override init() {
        self.cache.countLimit = 20
    }
    
    func getContent(urlString:String,timestamp:String, completeClosure: @escaping CompletionHandle) {
        let key = NSString(string: urlString+timestamp)
        
        //先从内存中取
        if let content = self.cache.object(forKey: key) as String? {
            completeClosure(content)
            return
        }
        
        //从本地读取
        DispatchQueue.global().async {
            var content = ""
            if let model = ArchiveManager.fetchResponseContent(timestamp: timestamp, urlString: urlString){
                if model.res_code == 0 ,let json = model.content{
                    content = json
                    self.cache.setObject(NSString(string: content), forKey: key)
                }
            }
            completeClosure(content)
        }
    }
}
