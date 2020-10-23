//
//  AppDelegate.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/21.
//  Copyright © 2020 李学敏. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var timerId:String?
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = UINavigationController(rootViewController: ViewController())
        self.window?.makeKeyAndVisible()
        
        requestGithub()
        
        return true
    }
    
    func requestGithub(){
        
        guard timerId == nil else {return}
        timerId = XMTimer.execTask(task: {
            let operation = RequestOperation.init(urlString: githubAPI)
            self.downloadQueue.addOperation(operation)
        }, start: 5, interval: 5, repeats: true, async: true)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        XMTimer.cancelTask(name: timerId)
        timerId = nil
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        requestGithub()
    }
}

