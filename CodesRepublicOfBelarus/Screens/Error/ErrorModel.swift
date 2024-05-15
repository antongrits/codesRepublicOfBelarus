//
//  ErrorWrapper.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 29.03.24.
//

import Foundation

struct ErrorModel: Identifiable {
    let id: UUID
    let error: Error
    let guidance: String
    
    init(id: UUID = UUID(), error: Error, guidance: String) {
        self.id = id
        self.error = error
        self.guidance = guidance
    }
}
