//
//  SearchViewModel.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 11.04.24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var isSearchViewShow = false
    @Published var searchString = ""
    var searchResultPrevCounter = 0
    @Published var searchResultCounter = 0
    @Published var searchResultTotalCount = 0
    
    var subscriptions = Set<AnyCancellable>()
}
