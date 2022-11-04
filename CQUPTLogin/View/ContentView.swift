//
//  ContentView.swift
//  CQUPTLogin
//
//  Created by Jerrita on 2022/11/2.
//

import SwiftUI
import Toast

struct ContentView: View {
    @State var bdhtml: String?
    let baiduUrl = URL(string: "https://ifconfig.me")!
    
    init() {
        // Make sure base.json exists
                if (fileManager.fileExists(atPath: documentUrl.appending(path: "base.json").relativePath)) {
                    MakeToast("配置加载完成")
                } else {
                    MakeToast("未检测到有效配置, 创建中")
                    do {
                        let baseUrl = Bundle.main.url(forResource: "base", withExtension: "json")
                        try fileManager.copyItem(at: baseUrl!, to: documentUrl.appending(path: "base.json"))
                    } catch {
                        MakeToast("配置文件创建失败")
                    }
                }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("校园网自动登录")
                .font(.headline)
            VStack {
                LoginView()
                    .padding()
            }
            .padding(.top, 80)
            Spacer()
            HStack {
                Text("公网:")
                Button("测试") {
                    print("Start test")
                    bdhtml = nil
                    Task {
                        do {
                            bdhtml = try await requestsGet(baiduUrl, .utf8)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            VStack{
                if let html = bdhtml {
                    Text(html)
                } else {
                    Text("Waiting...")
                }
            }.task {
                do {
                    bdhtml = try await requestsGet(baiduUrl, .utf8)
                } catch {
                    print(error)
                }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
