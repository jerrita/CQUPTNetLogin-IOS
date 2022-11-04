//
//  User.swift
//  CQUPTLogin
//
//  Created by Jerrita on 2022/11/2.
//

import Foundation


struct User: Hashable, Codable {
    var loginType: Int
    var deviceType: String
    var username: String
    var password: String
}
