//
//  CodesAPI.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 7.04.24.
//

import Foundation
import Combine

class CodesAPI {
    static let shared = CodesAPI()
    
    func fetchHtml(regNum: String) -> AnyPublisher<String, CodeHtmlErrorModel> {
        return Future<String, CodeHtmlErrorModel> { [unowned self] promise in
            let parameters = "type=GZIPText&RegNum=\(regNum)"
            let postData =  parameters.data(using: .utf8)

            guard let url = URL(string: "https://etalonline.by/api/XMLProcessor.ashx") else {
                return promise(.failure(.urlError(URLError(.unsupportedURL))))
            }
            
            var request = URLRequest(url: url, timeoutInterval: Double.infinity)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            request.httpMethod = "POST"
            request.httpBody = postData

            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> String in
                    guard let httpResponse = response as? HTTPURLResponse,
                          200...299 ~= httpResponse.statusCode else {
                        throw CodeHtmlErrorModel.responseError(
                            ((response as? HTTPURLResponse)?.statusCode ?? 500, String(data: data, encoding: .utf8) ?? ""))
                    }
                    return String(data: data, encoding: .utf8) ?? ""
                }
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            switch error {
                            case let urlError as URLError:
                                promise(.failure(.urlError(urlError)))
                            case let apiError as CodeHtmlErrorModel:
                                promise(.failure(apiError))
                            default:
                                promise(.failure(.unknownError))
                            }
                        }
                    },
                    receiveValue: { promise(.success($0)) }
                )
                .store(in: &self.subscriptions)
        }
        .eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
}

