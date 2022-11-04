//
//  MakeToast.swift
//  CQUPTLogin
//
//  Created by Jerrita on 2022/11/4.
//

import Foundation
import Toast

let myToastConfig = ToastConfiguration(
    autoHide: true,
    enablePanToClose: true,
    displayTime: 1,
    animationTime: 0.2
)

func MakeToast(_ text: String) {
    Toast.text(text, config: myToastConfig).show()
}
