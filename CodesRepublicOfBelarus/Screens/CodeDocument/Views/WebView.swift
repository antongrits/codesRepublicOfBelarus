//
//  WebView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 3.04.24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var wrapperWebViewModel: WrapperWebViewModel
    var searchViewModel: SearchViewModel
    var articlesViewModel: ArticlesViewModel
    var shareViewModel: ShareViewModel
    var bookmarkViewModel: BookmarkViewModel
    var codeModel: CodeModel
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        
        guard let path = Bundle.main.path(forResource: "WebViewSearch", ofType: "js"), let jsString = try? String(contentsOfFile: path, encoding: .utf8) else {
            print("The JS file was not found, or its contents could not be converted to a string!")
            return WKWebView(frame: .zero, configuration: configuration)
        }
        let userContentController = WKUserContentController()
        let userScript = WKUserScript(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(userScript)
        userContentController.add(context.coordinator, contentWorld: .page, name: "messageAppHandler")
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        searchViewModel.$searchString
            .debounce(for: .seconds(0.6), scheduler: DispatchQueue.main)
            .sink { [unowned searchViewModel] in
                if !$0.isEmpty {
                    let startSearch = "WKWebView_HighlightAllOccurencesOfString('\($0)')"
                    
                    webView.find($0) { result in
                        if result.matchFound {
                            webView.evaluateJavaScript(startSearch) { result, error in
                                if error != nil {
                                    print("WKWebView_HighlightAllOccurencesOfString: \(String(describing: error))")
                                    return
                                }
                                
                                webView.evaluateJavaScript("WKWebView_SearchResultCount") { result, error in
                                    if error != nil {
                                        print("WKWebView_SearchResultCount: \(String(describing: error))")
                                        return
                                    }
                                    if let result = result as? Int {
                                        searchViewModel.searchResultPrevCounter = 0
                                        searchViewModel.searchResultCounter = 1
                                        searchViewModel.searchResultTotalCount = result
                                    }
                                }
                            }
                        } else {
                            searchViewModel.searchResultPrevCounter = 0
                            searchViewModel.searchResultCounter = 0
                            searchViewModel.searchResultTotalCount = 0
                            webView.evaluateJavaScript("WKWebView_RemoveAllHighlights()")
                        }
                    }
                } else {
                    searchViewModel.searchResultPrevCounter = 0
                    searchViewModel.searchResultCounter = 0
                    searchViewModel.searchResultTotalCount = 0
                    
                    webView.evaluateJavaScript("WKWebView_RemoveAllHighlights()")
                }
            }
            .store(in: &searchViewModel.subscriptions)
        
        searchViewModel.$searchResultCounter
            .debounce(for: .seconds(0.0005), scheduler: DispatchQueue.main)
            .sink { [unowned searchViewModel] _ in
                if searchViewModel.isSearchViewShow {
                    
                    if searchViewModel.searchResultPrevCounter < searchViewModel.searchResultCounter {
                        webView.evaluateJavaScript("WKWebView_SearchNext()")
                    } else if searchViewModel.searchResultPrevCounter > searchViewModel.searchResultCounter {
                        webView.evaluateJavaScript("WKWebView_SearchPrev()")
                    }
                    searchViewModel.searchResultPrevCounter = searchViewModel.searchResultCounter
                }
            }
            .store(in: &searchViewModel.subscriptions)
        
        articlesViewModel.$currArticle
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink {
                if $0 != nil {
                    webView.evaluateJavaScript("scrollToElement('\($0!.className)', '\($0!.idName)')")
                }
            }
            .store(in: &articlesViewModel.subscriptions)
        
        shareViewModel.isShareButtonPressed
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .sink { [unowned shareViewModel] in
                if $0 {
                    let pdfConfiguration = WKPDFConfiguration()
                    pdfConfiguration.rect = CGRect(x: 0, y: 0, width: webView.scrollView.contentSize.width, height: webView.scrollView.contentSize.height)
                    webView.createPDF(configuration: pdfConfiguration) { result in
                        switch result {
                        case .success(let pdfData):
                            shareViewModel.saveToFile(for: pdfData, fileName: codeModel.name)
                            
                        case .failure(let error):
                            print("Ошибка при создании PDF: \(error.localizedDescription)")
                        }
                    }
                }
            }
            .store(in: &shareViewModel.cansellableSet)
        
        bookmarkViewModel.bookmarkResponse
            .debounce(for: .seconds(0.15), scheduler: DispatchQueue.main)
            .sink { bookmark in
                webView.evaluateJavaScript("setSvgIconByClassAndId('\(bookmark.className)', '\(bookmark.idName)', '\(bookmark.svgId == "bookmarkChecked" ? "bookmarkNotChecked" : "bookmarkChecked")')")
            }
            .store(in: &bookmarkViewModel.cansellableSet)
        
        bookmarkViewModel.isRemoveAllScriptMessageHandlers
            .sink {
                if $0 {
                    userContentController.removeAllUserScripts()
                    userContentController.removeAllScriptMessageHandlers()
                }
            }
            .store(in: &bookmarkViewModel.cansellableSet)
        
        bookmarkViewModel.isRemoveAllBookmarks
            .sink {
                if $0 {
                    webView.evaluateJavaScript("resetSvgIcons()")
                }
            }
            .store(in: &bookmarkViewModel.cansellableSet)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.navigationDelegate = context.coordinator
        uiView.loadHTMLString(wrapperWebViewModel.html, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, self.articlesViewModel)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView
        var articlesViewModel: ArticlesViewModel
        
        init(_ webView: WebView, _ articlesViewModel: ArticlesViewModel) {
            self.parent = webView
            self.articlesViewModel = articlesViewModel
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if case .wrapperWebView(_) = parent.viewRouter.currentPage {
                if parent.wrapperWebViewModel.html != "" {
                    webView.evaluateJavaScript(getArticles) { result, error in
                        if let error = error {
                            print("Ошибка при выполнении JavaScript: \(error.localizedDescription)")
                            return
                        }
                        
                        guard let resultString = result as? String else {
                            print("Результат JavaScript не является строкой")
                            return
                        }
                        
                        Task {
                            await self.articlesViewModel.decodeArticles(articlesJson: resultString)
                        }
                    }
                    webView.evaluateJavaScript(addBookmarks)
                    webView.evaluateJavaScript(addMetaTeg)
                    webView.evaluateJavaScript(removeHref)
                    webView.evaluateJavaScript(removeNbsp)
                    webView.evaluateJavaScript(removeLinks)
                    webView.evaluateJavaScript(hideRekviziti)
                    webView.evaluateJavaScript(linkCss())
                    
                    if self.parent.wrapperWebViewModel.html != "" || self.parent.wrapperWebViewModel.codeHtmlError != nil {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                            self.parent.wrapperWebViewModel.isLoaderVisible.send(false)
                        }
                        
                        if !parent.codeModel.bookmarks.isEmpty {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                                self.parent.codeModel.bookmarks.forEach { bookmark in
                                    webView.evaluateJavaScript("setSvgIconByClassAndId('\(bookmark.className)', '\(bookmark.idName)', 'bookmarkChecked')")
                                }
                                
                                webView.evaluateJavaScript("scrollToElement('\(self.parent.codeModel.bookmarks[0].className)', '\(self.parent.codeModel.bookmarks[0].idName)')")
                                self.parent.bookmarkViewModel.currentAlert = .moveToBookmark
                                self.parent.bookmarkViewModel.isAlertBookmarkVisible.send(true)
                            }
                        }
                    }
                }
            }
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            self.parent.wrapperWebViewModel.isLoaderVisible.send(true)
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            self.parent.wrapperWebViewModel.isLoaderVisible.send(false)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            self.parent.wrapperWebViewModel.isLoaderVisible.send(false)
        }
        
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            self.parent.wrapperWebViewModel.isLoaderVisible.send(false)
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }
            
            if !url.absoluteString.contains("https") {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
                DispatchQueue.main.async {
                    UIApplication.shared.open(url)
                }
            }
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "messageAppHandler" {
                if let bookmarkJSON = message.body as? String {
                    guard let jsonData = bookmarkJSON.data(using: .utf8),
                          let bookmark = try? JSONDecoder().decode(BookmarkResponse.self, from: jsonData) else { return }
                    parent.bookmarkViewModel.bookmarkResponse.send(bookmark)
                }
            }
        }
    }
}
