//
//  SupportEmailModel.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 2.05.24.
//

import SwiftUI

struct SupportEmailModel {
    let toAddress: String
    let subject: String
    let messageHeader: String
    var body: String {"""
        Application Name: \(Bundle.main.displayName)
        iOS: \(UIDevice.current.systemVersion)
        Device Model: \(UIDevice.current.modelName)
        App Version: \(Bundle.main.appVersion)
        App Build: \(Bundle.main.appBuild)
        \(messageHeader)
    --------------------------------------
    """
    }
}
