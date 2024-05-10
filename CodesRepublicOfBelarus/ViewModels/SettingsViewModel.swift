//
//  SettingsViewModel.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 1.05.24.
//

import Foundation
import WebKit
import Combine

class SettingsViewModel {
    var isAlertClearCacheVisible = PassthroughSubject<Bool, Never>()
    
    func clearCookiesAndCache() {
        guard let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeLocalStorage, WKWebsiteDataTypeCookies]) as? Set<String> else { return }
        let dateFrom = Date.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: dateFrom) { [unowned self] in
            self.isAlertClearCacheVisible.send(true)
        }
        URLCache.shared.removeAllCachedResponses()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    }
}
