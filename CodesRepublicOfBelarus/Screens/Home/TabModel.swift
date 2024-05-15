//
//  Tab.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 24.03.24.
//

enum TabModel: String, CaseIterable {
    case all = "Все"
    case saved = "Сохранённые"
    
    var systemImage: String {
        switch self {
        case .all:
            return "book"
        case .saved:
            return "tray.and.arrow.down"
        }
    }
}
