//
//  CodeHtmlErrorModel.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 7.04.24.
//

import Foundation

enum CodeHtmlErrorModel: Error, LocalizedError, Identifiable {
    var id: String { localizedDescription }
    case urlError(URLError)
    case responseError((Int, String))
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .urlError(let error):
            return error.localizedDescription
            
        case .responseError((let status, let message)):
            return "Неверный код ответа: \(status), \(message)"
            
        case .unknownError:
            return "Произошла неизвестная ошибка!"
        }
    }
}
