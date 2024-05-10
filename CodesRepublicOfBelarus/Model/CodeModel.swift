//
//  CodeModel.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 23.03.24.
//

import Foundation
import SwiftData

@Model
class CodeModel: Identifiable {
    @Attribute(.unique) let id: String
    let name: String
    let desc: String
    let imageName: String
    var isChosen: Bool
    var html: String?
    var bookmarks: [BookmarkModel]
    
    init(id: String, name: String, desc: String, imageName: String, isChosen: Bool = false, html: String? = nil, bookmarks: [BookmarkModel] = []) {
        self.id = id
        self.name = name
        self.desc = desc
        self.imageName = imageName
        self.isChosen = isChosen
        self.html = html
        self.bookmarks = bookmarks
    }
}
