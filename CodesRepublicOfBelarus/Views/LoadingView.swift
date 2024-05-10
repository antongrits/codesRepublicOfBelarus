//
//  LoadingView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 3.04.24.
//

import SwiftUI

struct LoadingView: View {
    @State var isAnimating: Bool = false
    let timing: Double
    
    let frame: CGSize
    let primaryColor: Color
    
    init(color: Color = .myDarkPurple, size: CGFloat = 100, speed: Double = 0.4) {
        timing = speed * 2
        frame = CGSize(width: size, height: size)
        primaryColor = color
    }

    var body: some View {
        ZStack {
            HStack(spacing: frame.width / 40) {
                ForEach(0..<10) { index in
                    
                    Circle()
                        .fill(primaryColor)
                        .offset(y: isAnimating ? frame.height / 6 : -frame.height / 6)
                        .animation(
                            Animation
                                .easeInOut(duration: timing)
                                .repeatForever(autoreverses: true)
                                .delay(timing / Double(10) * Double(index))
                            , value: isAnimating
                        )
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .opacity(isAnimating ? 1.0 : 0.8)
                        .animation(Animation.easeInOut(duration: timing).repeatForever(autoreverses: true), value: isAnimating)

                }
            }
            
            HStack(spacing: frame.width / 40) {
                ForEach(0..<10) { index in
                    
                    Circle()
                        .fill(primaryColor)
                        .offset(y: isAnimating ? -frame.height / 6 : frame.height / 6)
                        .animation(
                            Animation
                                .easeInOut(duration: timing)
                                .repeatForever(autoreverses: true)
                                .delay(timing / Double(10) * Double(index))
                            , value: isAnimating
                        )
                        .scaleEffect(isAnimating ? 0.8 : 1.0)
                        .opacity(isAnimating ? 0.8 : 1.0)
                        .animation(Animation.easeInOut(duration: timing).repeatForever(autoreverses: true), value: isAnimating)

                }
            }
            
        }
        .frame(width: frame.width, height: frame.height, alignment: .center)
        .onAppear {
            isAnimating.toggle()
        }
    }
}


#Preview {
    LoadingView()
}
