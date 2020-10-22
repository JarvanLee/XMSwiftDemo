//
//  ArchiveManager.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/22.
//  Copyright © 2020 李学敏. All rights reserved.
//

import UIKit

/// 文件目录
let documentDirectoryInUserDomainMask = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
let acrchivesRootFolder =  "\(documentDirectoryInUserDomainMask ?? "")/XMSwiftDemoArchives"

struct ArchiveManager {
    
    // MARK: -- 保存请求记录
    static func saveRequestHistory(timestamp:String,urlString:String){
        
        let model = self.fetchRequestHistory(urlString: urlString) ?? RequestHistoryModel()
        model.timestamps.insert(timestamp, at: 0)
        do {
            let data = try PropertyListEncoder().encode(model)
            var path = acrchivesRootFolder + "/History"
            if (self.creatFilePath(path)) {
                path = path + "/" + MD5(urlString)
            }
            NSKeyedArchiver.archiveRootObject(data, toFile:path)
        } catch {
            
        }
    }
    
    // MARK: -- 获取请求记录
    static func fetchRequestHistory(urlString:String) -> RequestHistoryModel?{
        var path = acrchivesRootFolder + "/History"
        if (self.creatFilePath(path)) {
            path = path + "/" + MD5(urlString)
        }
        if let unarchiveData = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data {
            do {
                let content = try PropertyListDecoder().decode(RequestHistoryModel.self, from: unarchiveData)
                return content
            } catch {
                
            }
        }
        return nil
    }
    
    // MARK: -- 保存请求下来的数据
    static func saveResponseModel(_ model:CacheModel ,urlString:String){
        do {
            let data = try PropertyListEncoder().encode(model)
            var path = acrchivesRootFolder + "/" + MD5(urlString)
            if (self.creatFilePath(path)) {
                path = path + "/" + model.timestamp
            }
            NSKeyedArchiver.archiveRootObject(data, toFile:path)
        } catch {
            
        }
    }
    
    
    // MARK: -- 取得目录下所有文件名
    static func getAllFileName(urlString: String) -> [String]? {
        var filePaths = [String]()
        
        do {
            let path = acrchivesRootFolder + "/" + MD5(urlString)
            let array = try FileManager.default.contentsOfDirectory(atPath: path)
            filePaths += array
            
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
        
        return filePaths;
    }
    
    // MARK: -- 从存储文件中获取 目录
    static func fetchResponseContent(timestamp:String,urlString:String) -> CacheModel? {
        var path = acrchivesRootFolder + "/" + MD5(urlString)
        if (self.creatFilePath(path)) {
            path = path + "/" + timestamp
        }
        if let unarchiveData = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data {
            do {
                let content = try PropertyListDecoder().decode(CacheModel.self, from: unarchiveData)
                return content
            } catch {
                
            }
        }
        return nil
    }
    
    // MARK: -- 删除某url的缓存
    static func removeArchivers(urlString:String){
        let path = acrchivesRootFolder + "/" + MD5(urlString)
        guard FileManager.default.fileExists(atPath: path) else { return }
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch { }
    }
    
    // MARK: -- 创建文件夹
    static func creatFilePath(_ filePath: String) -> Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            return true
        }
        do {
            try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            
        }
        return false
    }
}

