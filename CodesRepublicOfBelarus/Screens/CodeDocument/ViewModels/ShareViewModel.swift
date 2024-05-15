//
//  ShareViewModel.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 18.04.24.
//

import Foundation
import Combine

class ShareViewModel {
    var pdfURL: URL?
    var isShareButtonPressed = PassthroughSubject<Bool, Never>()
    var isShareViewVisible = PassthroughSubject<Bool, Never>()
    var cansellableSet: Set<AnyCancellable> = []
    
    func saveToFile(for data: Data, fileName: String) {
        let documentDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let outputFileURL = documentDirectory.appending(path: "\(fileName).pdf")
        do {
            try data.write(to: outputFileURL, options: .atomic)
            pdfURL = outputFileURL
            isShareViewVisible.send(true)
        } catch {
            print("Ошибка при выполнении сохранения PDF: \(error.localizedDescription)")
        }
    }
    
    func deleteFile() {
        do {
            try FileManager.default.removeItem(at: pdfURL!)
            pdfURL = nil
        } catch {
            print("Ошибка при выполнении удаления PDF: \(error.localizedDescription)")
        }
    }
}
