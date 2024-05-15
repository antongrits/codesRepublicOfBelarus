//
//  SearchView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 11.04.24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @FocusState private var textfieldFocused: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                textfieldFocused = false
                searchViewModel.isSearchViewShow.toggle()
                searchViewModel.searchString = ""
                searchViewModel.searchResultCounter = 0
                searchViewModel.searchResultPrevCounter = 0
                searchViewModel.searchResultTotalCount = 0
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.myDarkPurple)
                    .font(.system(size: 19))
            }
            TextField("Поиск по документу...", text: $searchViewModel.searchString)
                .focused($textfieldFocused)
                .onLongPressGesture(minimumDuration: 0.0) {
                    textfieldFocused = true
                }
                .autocorrectionDisabled()
                .font(.system(size: 14))
                .padding(7)
                .background(in: .rect(cornerRadius: 10))
                
            Stepper(value: $searchViewModel.searchResultCounter, in: 0...searchViewModel.searchResultTotalCount, step: 1) {
                Text("\(searchViewModel.searchResultCounter) из \(searchViewModel.searchResultTotalCount)")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 12))
            }
            .frame(width: 145)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(.myLightGray)
        .onAppear {
            textfieldFocused = true
        }
    }
}
