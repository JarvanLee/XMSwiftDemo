//
//  GithubModel.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/21.
//  Copyright © 2020 李学敏. All rights reserved.
//

import UIKit

class RequestHistoryModel:Codable {
    var timestamps:[String] = []
}


struct CacheModel:Codable{
    
    var timestamp:String
    var content:String?
    var res_msg:String?
    var res_code:Int = 0    //0成功
    
    init(timestamp: String) {
        self.timestamp = timestamp
    }
}
