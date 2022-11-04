//
//  LoginView.swift
//  CQUPTLogin
//
//  Created by Jerrita on 2022/11/2.
//

import SwiftUI
import Toast

struct LoginView: View {
    @State var user: User = load("base.json");
    @State var deviceIP: String?
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("登录类型:")
                    Picker(selection: $user.loginType, label: Text("设备类型")) {
                        Text("PC").tag(0)
                        Text("Mobile").tag(1)
                    }
                }
                
                HStack {
                    Text("网络类型:")
                    Picker(selection: $user.deviceType, label: Text("网络类型")) {
                        Text("电信").tag("telecom")
                        Text("移动").tag("mobile")
                    }
                }
                
                HStack {
                    Text("IP: ")
                    if let deviceIP = deviceIP {
                        Text(deviceIP)
                    } else {
                        Text("Waiting...")
                    }
                }
                .task {
                    deviceIP = await getDeviceIP()
                }
                
                HStack {
                    Text("用户名:")
                    TextField("Username", text: $user.username)
                }
                
                HStack {
                    Text("密码:")
                    SecureField("Password", text: $user.password )
                }
            }
            HStack {
                Button("保存") {
                    save(user, "base.json")
                    MakeToast("保存成功!")
                }
                Button("读取") {
                    user = load("base.json");
                    getDeviceIPTask()
                    MakeToast("读取完成!")
                }.padding(.leading)
                Button("获取IP") {
                    deviceIP = nil
                    Task {
                        deviceIP = await getDeviceIP()
                    }
                }
                .padding(.leading)
                Button("登录") {
                    if deviceIP != nil && deviceIP != "Error!" {
                        print("准备登录:", user, deviceIP!)
                        Task {
                            MakeToast(await loginCQUPTNet(user, deviceIP!))
                        }
                    } else {
                        MakeToast("请先获取 IP")
                    }
                }
                .padding(.leading)
            }.padding(.top)
        }.padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
