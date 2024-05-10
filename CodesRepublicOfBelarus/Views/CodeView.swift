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

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CodeModel.self, configurations: config)
        let example1 = CodeModel(id: "hk1", name: "Банковский кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 25 октября 2000 г. №441-З", imageName: "bankCode", isChosen: false)
        let example2 = CodeModel(id: "hk2", name: "Бюджетный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 16 июля 2008 г. №412-З", imageName: "budgetCode", isChosen: false, html: "<html>")
        let example3 = CodeModel(id: "hk3", name: "Водный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 30 апреля 2014 г. №149-З", imageName: "waterCode", isChosen: false, html: "<html>")
        let example4 = CodeModel(id: "hk4", name: "Водный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 30 апреля 2014 г. №149-З", imageName: "waterCode", isChosen: false, html: "<html>")
        let example5 = CodeModel(id: "hk5", name: "Водный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 30 апреля 2014 г. №149-З", imageName: "waterCode", isChosen: false, html: "<html>")
        let example6 = CodeModel(id: "hk6", name: "Водный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 30 апреля 2014 г. №149-З", imageName: "waterCode", isChosen: false, html: "<html>")
        let example7 = CodeModel(id: "hk7", name: "Водный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 30 апреля 2014 г. №149-З", imageName: "waterCode", isChosen: false, html: "<html>")
        let example8 = CodeModel(id: "hk8", name: "Водный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 30 апреля 2014 г. №149-З", imageName: "waterCode", isChosen: false, html: "<html>")
        let example9 = CodeModel(id: "hk9", name: "Водный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 30 апреля 2014 г. №149-З", imageName: "waterCode", isChosen: false, html: "<html>")
        let example10 = CodeModel(id: "hk10", name: "Водный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 30 апреля 2014 г. №149-З", imageName: "waterCode", isChosen: false, html: "<html>")
        let example11 = CodeModel(id: "hk11", name: "Водный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 30 апреля 2014 г. №149-З", imageName: "waterCode", isChosen: false, html: "<html>")
        let example12 = CodeModel(id: "hk12", name: "Водный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 30 апреля 2014 г. №149-З", imageName: "waterCode", isChosen: false, html: "<html>")
        container.mainContext.insert(example1)
        container.mainContext.insert(example2)
        container.mainContext.insert(example3)
        container.mainContext.insert(example4)
        container.mainContext.insert(example5)
        container.mainContext.insert(example6)
        container.mainContext.insert(example7)
        container.mainContext.insert(example8)
        container.mainContext.insert(example9)
        container.mainContext.insert(example10)
        container.mainContext.insert(example11)
        container.mainContext.insert(example12)
        return MotherView()
            .modelContainer(container)
            .environmentObject(ViewRouter())
    } catch {
        fatalError(error.localizedDescription)
    }
}
