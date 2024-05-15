//
//  BookmarkViewModel.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 21.04.24.
//

import Foundation
import Combine

struct BookmarkResponse: Decodable {
    let className: String
    let idName: String
    let svgId: String
}

class BookmarkViewModel {
    var bookmarkResponse = PassthroughSubject<BookmarkResponse, Never>()
    var currentAlert: AlertsForBookmarks?
    var isAlertBookmarkVisible = PassthroughSubject<Bool, Never>()
    var isRemoveAllScriptMessageHandlers = PassthroughSubject<Bool, Never>()
    var isRemoveAllBookmarks = PassthroughSubject<Bool, Never>()
    var cansellableSet: Set<AnyCancellable> = []
}
