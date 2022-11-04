//
//  logic.swift
//  CQUPTLogin
//
//  Created by Jerrita on 2022/11/3.
//

import Foundation
import Toast

extension String.Encoding {
    static let gb_18030_2000 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
}

let homeUrl = URL(string: "http://192.168.200.2")!
let loginUrlString = "http://192.168.200.2:801/eportal/?c=Portal&a=login&callback=dr1003&login_method=1&user_account=%%2C%d%%2C%@%%40%@&user_password=%@&wlan_user_ip=%@&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.3.3&v=8263"

let REIP = try! NSRegularExpression(pattern: "10\\.[0-9]+\\.[0-9]+\\.[0-9]+")
let RERES = try! NSRegularExpression(pattern: "\\{.*\\}")

func requestsGet(_ url: URL, _ encoding: String.Encoding) async throws -> String {
    let mySessionConfig = URLSessionConfiguration.default
    mySessionConfig.timeoutIntervalForRequest = 2
    mySessionConfig.timeoutIntervalForResource = 2
    
    let (data, _) = try await URLSession(configuration: mySessionConfig).data(from: url)
    let html = String(data: data, encoding: encoding)!
    return html
}

func firstMatch(_ regex: NSRegularExpression, _ text: String) -> String {
    let matches = regex.matches(in: text, range: NSRange(location: 0, length: text.count))
    
    for item in matches {
        return (text as NSString).substring(with: item.range)
    }
    
    return ""
}

func getDeviceIP() async -> String {
    do {
        let html = try await requestsGet(homeUrl, .gb_18030_2000)
        return firstMatch(REIP, html)
    } catch {
        return "Error!"
    }
}

func getDeviceIPTask() {
    MakeToast("IP 获取中")
    Task {
        await getDeviceIP()
    }
}

func loginCQUPTNet(_ user: User, _ deviceIP: String) async -> String{
    let loginUrl = URL(string: String(format: loginUrlString, arguments: [
        user.loginType, user.username, user.deviceType, user.password, deviceIP
    ]))!
    print(loginUrl)
    var data = try! await requestsGet(loginUrl, .gb_18030_2000)
    print("first time: ", firstMatch(RERES, data))
    data = try! await requestsGet(loginUrl, .gb_18030_2000)
    return firstMatch(RERES, data)
}
