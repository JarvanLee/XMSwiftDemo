//
//  XMSwiftDemoTests.swift
//  XMSwiftDemoTests
//
//  Created by 李学敏 on 2020/10/21.
//  Copyright © 2020 李学敏. All rights reserved.
//

import XCTest
@testable import XMSwiftDemo

class XMSwiftDemoTests: XCTestCase {

    
    //测试请求历史记录
    func testFetchAllRequestHistory() throws {
        let historyModel = ArchiveManager.fetchRequestHistory(urlString: githubAPI)
        XCTAssertNotNil(historyModel)
    }
    
    //测试存入历史记录
    func testInsertRequestHistory() {
        let timestamp = Date().milliStamp
        ArchiveManager.saveRequestHistory(timestamp: timestamp, urlString: githubAPI)
        
        let model = ArchiveManager.fetchRequestHistory(urlString: githubAPI)
        XCTAssertNotNil(model)
        XCTAssertEqual(model?.timestamps[0], timestamp)
    }
    
    //测试保存response数据
    func testResponseCache(){
        let timestamp = Date().milliStamp
        let cacheModel = CacheModel.init(timestamp: timestamp, content: "success")
        
        ArchiveManager.saveResponseModel(cacheModel, urlString: githubAPI)
        let model = ArchiveManager.fetchResponseContent(timestamp: timestamp, urlString: githubAPI)
        
        XCTAssertNotNil(model)
        XCTAssertEqual(model?.content, cacheModel.content)
    }

}
