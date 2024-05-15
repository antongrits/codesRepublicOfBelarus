//
//  WrapperWebView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 3.04.24.
//

import SwiftUI
import SwiftData

struct WrapperWebView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var wrapperWebViewModel = WrapperWebViewModel()
    @ObservedObject var searchViewModel = SearchViewModel()
    @ObservedObject var articlesViewModel = ArticlesViewModel()
    @State var isLoaderVisible = false
    @State var isAlertErrorVisible = false
    @State var isAlertInformationVisible = false
    @State var isAlertBookmarkVisible = false
    @State var isShareViewVisible = false
    var bookmarkViewModel = BookmarkViewModel()
    var shareViewModel = ShareViewModel()
    var codeModel: CodeModel
    
    var safeArea: UIEdgeInsets
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderWebView(
                wrapperWebViewModel: wrapperWebViewModel,
                searchViewModel: searchViewModel,
                articlesViewModel: articlesViewModel,
                isLoaderVisible: $isLoaderVisible,
                bookmarkViewModel: bookmarkViewModel,
                shareViewModel: shareViewModel,
                codeModel: codeModel
            )
            .padding(.bottom, 5)
            
            ZStack {
                VStack(spacing: 0) {
                    if searchViewModel.isSearchViewShow {
                        SearchView(searchViewModel: searchViewModel)
                    }
                    
                    WebView(
                        wrapperWebViewModel: wrapperWebViewModel,
                        searchViewModel: searchViewModel,
                        articlesViewModel: articlesViewModel,
                        shareViewModel: shareViewModel,
                        bookmarkViewModel: bookmarkViewModel,
                        codeModel: codeModel
                    )
                        .ignoresSafeArea(edges: .bottom)
                }
                
                if isLoaderVisible || isAlertInformationVisible {
                    VisualEffectView(effect: UIBlurEffect(style: .light))
                        .ignoresSafeArea(.all)
                }
                
                if isLoaderVisible {
                    LoadingView()
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, safeArea.top)
        .background(Color.myLightPurple.opacity(0.4).ignoresSafeArea())
        .alert("Ошибка сети", isPresented: $isAlertErrorVisible) {
            Button("OK", action: {
                withAnimation(.spring) {
                    viewRouter.currentPage = .codesView
                    bookmarkViewModel.isRemoveAllScriptMessageHandlers.send(true)
                    wrapperWebViewModel.cansellableSet = []
                    searchViewModel.subscriptions = []
                    shareViewModel.cansellableSet = []
                    bookmarkViewModel.cansellableSet = []
                }
            })
        } message: {
            Text(wrapperWebViewModel.codeHtmlError?.localizedDescription ?? "")
        }
        .toast(isPresenting: $isAlertBookmarkVisible, duration: 1.2, tapToDismiss: true) {
            AlertToast(displayMode: .banner(.pop), type: .systemImage("bookmark.fill", .red), title: bookmarkViewModel.currentAlert?.rawValue)
        }
        .toast(isPresenting: $isAlertInformationVisible, duration: 1.5, tapToDismiss: true) {
            if wrapperWebViewModel.currentAlert == .updateCode {
                codeModel.html = wrapperWebViewModel.html
            }
            
            return AlertToast(type: .complete(.green), title: wrapperWebViewModel.currentAlert?.rawValue)
        }
        .sheet(isPresented: $articlesViewModel.isArticlesShow) {
            ArticlesView(articlesViewModel: articlesViewModel, codeModel: codeModel)
        }
        .sheet(isPresented: $isShareViewVisible, onDismiss: { shareViewModel.deleteFile() }, content: {
            ShareView(urls: [shareViewModel.pdfURL!])
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.hidden)
                .ignoresSafeArea(edges: .bottom)
        })
        .sensoryFeedback(.success, trigger: isAlertInformationVisible)
        .sensoryFeedback(.error, trigger: isAlertErrorVisible)
        .onReceive(wrapperWebViewModel.isLoaderVisible.receive(on: RunLoop.main), perform: { value in
            isLoaderVisible = value
        })
        .onReceive(wrapperWebViewModel.isAlertErrorVisible.receive(on: RunLoop.main), perform: { value in
            isAlertErrorVisible = value
        })
        .onReceive(wrapperWebViewModel.isAlertInformationVisible.receive(on: RunLoop.main), perform: { value in
            isAlertInformationVisible = value
        })
        .onReceive(bookmarkViewModel.isAlertBookmarkVisible.receive(on: RunLoop.main), perform: { value in
            isAlertBookmarkVisible = value
        })
        .onReceive(shareViewModel.isShareViewVisible.receive(on: RunLoop.main), perform: { value in
            isShareViewVisible = value
        })
        .onReceive(bookmarkViewModel.bookmarkResponse.receive(on: RunLoop.main), perform: { bookmark in
            let bookmarkIndex = codeModel.bookmarks.firstIndex { object in
                object.idName == bookmark.idName
            }
            if bookmarkIndex != nil {
                codeModel.bookmarks.remove(at: bookmarkIndex!)
                bookmarkViewModel.currentAlert = .removeBookmark
                bookmarkViewModel.isAlertBookmarkVisible.send(true)
            } else {
                codeModel.bookmarks.insert(BookmarkModel(className: bookmark.className, idName: bookmark.idName), at: 0)
                bookmarkViewModel.currentAlert = .saveBookmark
                bookmarkViewModel.isAlertBookmarkVisible.send(true)
            }
        })
        .onAppear {
            if codeModel.html == nil {
                wrapperWebViewModel.fetchHtml(regNum: codeModel.id)
            } else {
                wrapperWebViewModel.html = codeModel.html!
            }
        }
    }
}
