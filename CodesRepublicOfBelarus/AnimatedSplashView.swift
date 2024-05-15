//
//  AnimatedSplashView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 2.05.24.
//

import SwiftUI

struct AnimatedSplashView: View {
    var color: String
    var logo: String
    var animationTiming = 0.9
    
    @State private var startAnimation = true
    
    var body: some View {
        VStack {
            if !startAnimation {
                AnimatedSideBarView()
            } else {
                ZStack {
                    Color(color)
                        
                    VStack(spacing: 0) {
                        Image(logo)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                        
                        Text("Кодексы РБ")
                            .font(.largeTitle.bold())
                            .padding(.vertical, 15)
                    }
                }
                .ignoresSafeArea()
            }
        }
        .onAppear {
            if startAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: animationTiming)) {
                        startAnimation = false
                    }
                }
            }
        }
    }
}
