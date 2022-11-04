//
//  ToastModel.swift
//  CQUPTLogin
//
//  Created by Jerrita on 2022/11/3.
//

import Foundation

struct FancyToast: Equatable {
    var type: FancyToastStyle
    var title: String
    var message: String
    var duration: Double = 3
}

