//
//  CodeView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 23.03.24.
//

import SwiftUI
import SwiftData

struct CodeView: View {
    var codeModel: CodeModel
    let color: Color
    let isTrue: CGFloat
    let isFalse: CGFloat
    let isSaved: Bool
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var scaleStar: CGFloat = 1.0
    @State var isFlipped = false
    
    private func codeImage(for codeModel: CodeModel) -> some View {
        return Image(codeModel.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(color.gradient)
            .frame(height: 265)
            .overlay {
                VStack(alignment: .center) {
                    HStack {
                        codeImage(for: codeModel)
                        Spacer()
                        Image(systemName: codeModel.isChosen ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.yellow)
                            .scaleEffect(scaleStar)
                            .animation(.spring(duration: 0.3), value: scaleStar)
                            .gesture(TapGesture()
                                .onEnded { _ in
                                    scaleStar = 1.6
                                    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                                        scaleStar = 1
                                    }
                                    Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
                                        codeModel.isChosen.toggle()
                                    }
                                }
                            )
                            .sensoryFeedback(.selection, trigger: codeModel.isChosen)
                    }
                    .padding(.bottom, 5)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.white.opacity(0.25))
                        .frame(height: 150)
                        .overlay {
                            VStack(alignment: .center) {
                                Text(isFlipped ? codeModel.desc : codeModel.name)
                                    .font(.system(size: 15))
                                    .multilineTextAlignment(.center)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(2)
                            }
                            .padding(2)
                        }
                        .padding(.bottom, 5)
                    
                    Spacer()
                    
                    if codeModel.html != nil {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.white.opacity(0.25))
                            .frame(width: 130)
                            .overlay {
                                HStack(alignment: .bottom) {
                                    Image(systemName: "tray.and.arrow.down")
                                        .font(.system(size: 16))
                                    Text("Сохранён")
                                        .font(.system(size: 15))
                                }
                                .padding(2)
                            }
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity)
            }
            .rotation3DEffect(
                .degrees(isFlipped ? isTrue : isFalse),
                                      axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .animation(.linear, value: isFlipped)
            .customContextMenu(code: codeModel, toggleIsFlipped: {
                isFlipped.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    isFlipped = false
                }
            }, isFlipped: isFlipped, isSaved: isSaved)
            .onTapGesture {
                withAnimation(.spring) {
                    viewRouter.currentPage = .wrapperWebView(codeModel)
                }
            }
    }
}
