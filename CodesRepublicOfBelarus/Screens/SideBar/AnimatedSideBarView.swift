//
//  AnimatedSideBar.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 27.04.24.
//

import SwiftUI
import SwiftData

struct AnimatedSideBarView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @AppStorage("rotatesWhenExpands") private var rotatesWhenExpands = true
    var disableInteraction = true
    var sideMenuWidth: CGFloat = 200
    var cornerRadius: CGFloat = 25
    @State private var showMenu = false
    
    @GestureState private var isDragging = false
    @State private var offsetX: CGFloat = 0
    @State private var lastOffsetX: CGFloat = 0
    @State private var progress: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
            
            HStack(spacing: 0) {
                GeometryReader { _ in
                    SideBarMenuView(safeArea)
                }
                .frame(width: sideMenuWidth)
                .contentShape(.rect)
                
                GeometryReader { _ in
                    switch viewRouter.currentPage {
                    case .codesView:
                        CodesView(showMenu: $showMenu, safeArea: safeArea)
                    case .wrapperWebView(let codeModel):
                        WrapperWebView(codeModel: codeModel, safeArea: safeArea)
                    case .settingsView:
                        SettingsView(rotatesWhenExpands: $rotatesWhenExpands, showMenu: $showMenu, safeArea: safeArea)
                    case .infoView:
                        InfoView(showMenu: $showMenu, safeArea: safeArea)
                    }
                }
                .frame(width: size.width)
                .overlay {
                    if disableInteraction && progress > 0 {
                        Rectangle()
                            .fill(.black.opacity(progress * 0.2))
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                                    reset()
                                }
                            }
                    }
                }
                .mask {
                    RoundedRectangle(cornerRadius: progress * cornerRadius)
                }
                .scaleEffect(rotatesWhenExpands ? 1 - (progress * 0.1) : 1, anchor: .trailing)
                .rotation3DEffect(
                    .init(degrees: rotatesWhenExpands ? (progress * -15) : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            }
            .frame(width: size.width + sideMenuWidth, height: size.height)
            .offset(x: -sideMenuWidth)
            .offset(x: offsetX)
            .contentShape(.rect)
            .simultaneousGesture(dragGesture)
        }
        .ignoresSafeArea()
        .onChange(of: showMenu, initial: true) { oldValue, newValue in
            withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                if newValue {
                    showSideBar()
                } else {
                    reset()
                }
            }
        }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .updating($isDragging) { _, out, _ in
                if case .wrapperWebView(_) = viewRouter.currentPage {
                    out = false
                } else {
                    out = true
                }
            }.onChanged { value in
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    guard value.startLocation.x > 10, isDragging else { return }
                    if case .wrapperWebView(_) = viewRouter.currentPage { return } else {
                        let translationX = isDragging ? max(min(value.translation.width + lastOffsetX, sideMenuWidth), 0) : 0
                        offsetX = translationX
                        calculateProgress()
                    }
                }
            }.onEnded { value in
                if case .wrapperWebView(_) = viewRouter.currentPage {} else {
                    withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                        let velocityX = value.velocity.width / 8
                        let total = velocityX + offsetX
                         
                        if total > (sideMenuWidth * 0.5) {
                            showSideBar()
                        } else {
                            reset()
                        }
                    }
                }
            }
    }
    
    func showSideBar() {
        offsetX = sideMenuWidth
        lastOffsetX = offsetX
        showMenu = true
        calculateProgress()
    }
    
    func reset() {
        offsetX = 0
        lastOffsetX = 0
        showMenu = false
        calculateProgress()
    }
    
    func calculateProgress() {
        progress = max(min(offsetX / sideMenuWidth, 1), 0)
    }
    
    @ViewBuilder
    func SideBarMenuView(_ safeArea: UIEdgeInsets) -> some View {
        VStack(alignment: .center) {
            Image("myAppIcon")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 140, height: 140)
                .clipShape(.rect(cornerRadius: 30))
            
            Text("Кодексы РБ")
                .font(.title.bold())
                .padding(.vertical, 15)
            
            SideBarButton(.codes, onTap: {
                viewRouter.currentPage = .codesView
                showMenu = false
            })
            SideBarButton(.settings, onTap: {
                viewRouter.currentPage = .settingsView
                showMenu = false
            })
            SideBarButton(.info, onTap: {
                viewRouter.currentPage = .infoView
                showMenu = false
            })
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .padding(.top, safeArea.top)
        .padding(.bottom, safeArea.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func SideBarButton(_ sideBarModel: SideBarModel, onTap: @escaping () -> ()) -> some View {
        Button(action: onTap, label: {
            HStack(spacing: 12) {
                Image(systemName: sideBarModel.systemImage)
                    .font(.title3)
                
                Text(sideBarModel.rawValue)
                    .font(.callout)
                
                Spacer(minLength: 0)
            }
            .padding(.vertical, 10)
            .contentShape(.rect)
            .foregroundStyle(Color.primary)
        })
    }
}
