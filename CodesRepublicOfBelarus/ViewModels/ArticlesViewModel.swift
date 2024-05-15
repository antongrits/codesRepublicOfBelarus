//
//  ArticlesViewModel.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 14.04.24.
//

import Foundation
import Combine

struct ArticleResponse: Decodable {
    let className: String
    let idName: String
    let text: String
}

class ArticlesViewModel: ObservableObject {
    @Published var isArticlesShow = false
    @Published var searchString = ""
    @Published var currArticle: ArticleModel?
    var articles = [ArticleModel]()
    
    func decodeArticles(articlesJson: String) async {
        let task = Task<[ArticleResponse], Never> {
            guard let jsonData = articlesJson.data(using: .utf8),
               let articlesResponse = try? JSONDecoder().decode([ArticleResponse].self, from: jsonData) else {
                return []
            }
            return articlesResponse
        }
        let articlesResponse = await task.value
        if articlesResponse.isEmpty == false {
            articlesResponse.forEach { article in
                articles.append(ArticleModel(className: article.className, idName: article.idName, text: article.text))
            }
        }
    }
    
    var subscriptions = Set<AnyCancellable>()
}
