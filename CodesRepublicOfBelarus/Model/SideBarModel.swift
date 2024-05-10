//
//  SideBarModel.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 30.04.24.
//

import Foundation

enum SideBarModel: String, CaseIterable {
    case codes = "Кодексы"
    case settings = "Настройки"
    case info = "О приложении"
    
    var systemImage: String {
        switch self {
        case .codes:
            return "books.vertical.fill"
        case .settings:
            return "gearshape.fill"
        case .info:
            return "info.circle.fill"
        }
    }
}
