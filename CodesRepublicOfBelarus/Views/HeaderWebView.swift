//
//  HeaderWebView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 3.04.24.
//

import SwiftUI
import SwiftData

struct HeaderWebView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var wrapperWebViewModel: WrapperWebViewModel
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var articlesViewModel: ArticlesViewModel
    @Binding var isLoaderVisible: Bool
    var bookmarkViewModel: BookmarkViewModel
    var shareViewModel: ShareViewModel
    var codeModel: CodeModel
    
    var body: some View {
        HStack {
            Button(action: {
                viewRouter.currentPage = .codesView
                bookmarkViewModel.isRemoveAllScriptMessageHandlers.send(true)
                wrapperWebViewModel.cansellableSet = []
                searchViewModel.subscriptions = []
                shareViewModel.cansellableSet = []
                bookmarkViewModel.cansellableSet = []
            }) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(.myDarkPurple)
            }
            Spacer()
            VStack {
                Text(codeModel.name)
                    .font(.system(size: 15).bold())
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                Text(codeModel.desc)
                    .font(.system(size: 13).italic())
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            Menu {
                if !isLoaderVisible {
                    Button(action: { searchViewModel.isSearchViewShow = true }) {
                        Label("Поиск", systemImage: "doc.text.magnifyingglass")
                    }
                    Button(action: { articlesViewModel.isArticlesShow = true }) {
                        Label("Оглавление", systemImage: "list.bullet")
                    }
                    Button(action: {
                        if codeModel.html != nil {
                            wrapperWebViewModel.currentAlert = .updateCode
                            wrapperWebViewModel.fetchHtml(regNum: codeModel.id)
                            wrapperWebViewModel.isLoaderVisible.send(true)
                        } else {
                            wrapperWebViewModel.currentAlert = .saveCode
                            codeModel.html = wrapperWebViewModel.html
                            wrapperWebViewModel.isAlertInformationVisible.send(true)
                        }
                    }) {
                        Label(codeModel.html == nil ? "Сохранить" : "Обновить", systemImage: codeModel.html == nil ? "square.and.arrow.down" : "arrow.triangle.2.circlepath.circle.fill")
                    }
                    Button(action: { shareViewModel.isShareButtonPressed.send(true) }) {
                        Label("Сохранить в виде PDF", systemImage: "square.and.arrow.up")
                    }
                }
                
                Button(action: {
                    codeModel.isChosen.toggle()
                    codeModel.isChosen ? (wrapperWebViewModel.currentAlert = .addToFavorites) : (wrapperWebViewModel.currentAlert = .removeFromFavorites)
                    wrapperWebViewModel.isAlertInformationVisible.send(true)
                }) {
                    Label(!codeModel.isChosen ? "Добавить в избранное" : "Удалить из избранного", systemImage: !codeModel.isChosen ? "star" : "star.fill")
                }
                
                if !isLoaderVisible && !codeModel.bookmarks.isEmpty {
                    Button(role: .destructive) {
                        codeModel.bookmarks.removeAll()
                        bookmarkViewModel.isRemoveAllBookmarks.send(true)
                        bookmarkViewModel.currentAlert = .removeAllBookmarks
                        bookmarkViewModel.isAlertBookmarkVisible.send(true)
                    } label: {
                        Label("Удалить все закладки", systemImage: "trash")
                    }
                }
                
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundStyle(.myDarkPurple)
            }
        }
        .font(.title2)
        .padding([.leading, .trailing], 10)
    }
}
