//
//  GlobalConfig.swift
//  XMSwiftDemo
//
//  Created by 李学敏 on 2020/10/21.
//  Copyright © 2020 李学敏. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

/// 刘海屏系列，以后需要更新
fileprivate let iPhoneXSeriesIdentifiers = ["iPhone10,3",
                                            "iPhone10,6",
                                            "iPhone11,2",
                                            "iPhone11,4",
                                            "iPhone11,6",
                                            "iPhone11,8",
                                            "iPhone12,1",
                                            "iPhone12,3",
                                            "iPhone12,5",
                                            "iPhone12,8",
                                            "iPhone13,1",
                                            "iPhone13,2",
                                            "iPhone13,3",
                                            "iPhone13,4"]

struct DeviceInfo {

    /// iPhone X/XS/XR/XS Max 判断
    static var iPhoneXSeries: Bool {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { id, element in
            guard let value = element.value as? Int8, value != 0 else { return id }
            return id + String(UnicodeScalar(UInt8(value)))
        }
        if identifier == "i386" || identifier == "x86_64" {
            if let simulatorModelIdentifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] {
                return iPhoneXSeriesIdentifiers.contains(simulatorModelIdentifier)
            } else {
                return false
            }
        } else {
            return iPhoneXSeriesIdentifiers.contains(identifier)
        }
    }
}

/// 屏幕宽度
let screenWidth: CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高度
let screenHeight: CGFloat = UIScreen.main.bounds.size.height

/// x导航栏高度
let XnavigationBarHeight: CGFloat = DeviceInfo.iPhoneXSeries ? 88: 64

/// x底部高度
let XSafeAreaBottomHeight: CGFloat = DeviceInfo.iPhoneXSeries ? 34: 0

let githubAPI :String = "https://api.github.com"

extension Date {

    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}

class DateFormatterInstance {
    
    static let shared = DateFormatterInstance()
    
    fileprivate let formatter = DateFormatter()
    
    func displayTimeString(_ timeInterval: TimeInterval?) -> String? {
        if let timeInterval = timeInterval {
            formatter.dateFormat = "yyyy年M月d日 HH:mm:ss"
            return formatter.string(from: Date(timeIntervalSince1970: timeInterval/1000))
        } else {
            return nil
        }
    }
}

func printLog<T>( _ message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}


/// md5
func MD5(_ str: String) -> String {
    let cStr = str.cString(using: String.Encoding.utf8);
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
    CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
    let md5String = NSMutableString()
    for i in 0 ..< 16{
        md5String.appendFormat("%02x", buffer[i])
    }
    free(buffer)
    return md5String as String
}
