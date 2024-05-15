//
//  VisualEffectView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 21.04.24.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
