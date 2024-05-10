//
//  WrapperWebViewModel.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 3.04.24.
//

import Foundation
import Combine

class WrapperWebViewModel: ObservableObject {
    @Published var html = ""
    var codeHtmlError: CodeHtmlErrorModel?
    var currentAlert: Alerts?
    var isLoaderVisible = PassthroughSubject<Bool, Never>()
    var isAlertErrorVisible = PassthroughSubject<Bool, Never>()
    var isAlertInformationVisible = PassthroughSubject<Bool, Never>()
    var cansellableSet: Set<AnyCancellable> = []
    
    func fetchHtml(regNum: String) {
        CodesAPI.shared.fetchHtml(regNum: regNum)
            .sink(
                receiveCompletion: { [unowned self] completion in
                    if case let .failure(error) = completion {
                        self.codeHtmlError = error
                        self.isAlertErrorVisible.send(true)
                    }
                },
                receiveValue: { [unowned self] value in
                    self.html = value
                    if self.currentAlert == .updateCode {
                        self.isAlertInformationVisible.send(true)
                    }
                }
            )
            .store(in: &self.cansellableSet)
    }
}
