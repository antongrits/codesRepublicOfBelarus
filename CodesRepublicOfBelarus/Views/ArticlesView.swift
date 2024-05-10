//
//  ArticlesView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 15.04.24.
//

import SwiftUI

struct ArticlesView: View {
    @ObservedObject var articlesViewModel: ArticlesViewModel
    var codeModel: CodeModel
    var filteredArticles: [ArticleModel] {
        guard !articlesViewModel.searchString.isEmpty else { return articlesViewModel.articles }
        return articlesViewModel.articles.filter({ $0.text.localizedCaseInsensitiveContains(articlesViewModel.searchString) })
    }
    
    var body: some View {
        NavigationStack {
            List(filteredArticles, id: \.id) { article in
                Button(action: {
                    articlesViewModel.currArticle = article
                    articlesViewModel.isArticlesShow = false
                }) {
                    HStack(alignment: .center) {
                        Text(article.text)
                            .font(.system(size: 16))
                            .fontWeight(.light)
                        
                        Spacer()
                        
                        if codeModel.bookmarks.contains(where: { object in object.idName == article.idName }) {
                            Image(systemName: "bookmark.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
            .navigationTitle("Оглавление")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $articlesViewModel.searchString, prompt: "Поиск по оглавнению...")
            .autocorrectionDisabled()
        }
    }
}
