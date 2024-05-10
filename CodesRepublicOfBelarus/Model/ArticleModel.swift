//
//  ChapterModel.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 14.04.24.
//

import Foundation

struct ArticleModel: Identifiable {
    let id = UUID()
    let className: String
    let idName: String
    let text: String
}
