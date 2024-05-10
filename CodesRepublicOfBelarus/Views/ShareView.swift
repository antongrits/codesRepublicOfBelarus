//
//  ShareView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 18.04.24.
//

import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    var urls: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController , context: Context) {}
}
