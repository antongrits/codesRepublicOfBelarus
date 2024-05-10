//
//  CodesJSONDecoder.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 30.03.24.
//

import Foundation

struct CodeResponse: Decodable {
    let id: String
    let name: String
    let desc: String
}

struct CodesJSONDecoder {
    static func decode(from fileName: String) -> [CodeResponse] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let codes = try? JSONDecoder().decode([CodeResponse].self, from: data) else {
            return []
        }
        return codes
    }
}
