//
//  XMTimer.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/21.
//  Copyright © 2020 李学敏. All rights reserved.
//

import UIKit

typealias TaskClosure = () -> ()

class XMTimer: NSObject {
    
    private static var timers :Dictionary<String,DispatchSourceTimer> = [:]
    private static let semaphore = DispatchSemaphore.init(value: 1)

    
    /// 创建定时器并执行，返回一个定时器的唯一标识
    /// - Parameters:
    ///   - task: 执行任务
    ///   - start: 延迟几秒开始
    ///   - interval: 重复间隔
    ///   - repeats: 是否重复执行
    ///   - async: 是否在子线程中执行
    static func execTask(task: @escaping TaskClosure,
                         start:TimeInterval = 0,
                         interval:TimeInterval = 1 ,
                         repeats:Bool = false ,
                         async:Bool = false) -> (String?){
        if interval <= 0 && repeats {
            return nil;
        }
        
        let queue = async ? DispatchQueue.global() :DispatchQueue.main
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer.resume()
        let startTime = DispatchTime.now() + .milliseconds(Int(start * 1000))
        timer.schedule(deadline:startTime, repeating: interval, leeway: DispatchTimeInterval.milliseconds(100))
        
        semaphore.wait()
        let name = "\(timers.count)"
        timers[name] = timer
        semaphore.signal()
        
        timer.setEventHandler {
            task()
            if !repeats {cancelTask(name: name)}
        }
        
        
        return name
    }
    
    
    /// 取消一个定时器
    /// - Parameter name: 定时器唯一标识
    static func cancelTask(name:String?){
        guard let name = name,name.count > 0 else {
            return
        }
        semaphore.wait()
        let timer = timers[name]
        if let timer = timer{
            timer.cancel()
            timers.removeValue(forKey: name)
        }
        semaphore.signal()
    }
    
}
