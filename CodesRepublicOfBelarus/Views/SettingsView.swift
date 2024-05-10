//
//  SettingsView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 30.04.24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var rotatesWhenExpands: Bool
    @Binding var showMenu: Bool
    @State private var isAlertClearCacheVisible = false
    @State private var showingConfirmation = false
    var settingsViewModel = SettingsViewModel()
    var safeArea: UIEdgeInsets
    
    var body: some View {
        VStack(spacing: 0) {
            HStack() {
                Button(action: {
                    showMenu.toggle()
                }) {
                    Image(systemName: showMenu ? "xmark" : "line.3.horizontal.decrease")
                        .contentTransition(.symbolEffect)
                }
                .font(.system(size: 19))
                .foregroundStyle(.primary)
                
                Spacer()
            }
            .overlay {
                Text("Настройки")
                    .font(.system(size: 19).bold())
            }
            .padding(10)
            .padding(.bottom, 5)
            .padding(.top, safeArea.top)
            .background(Color.myLightPurple.opacity(0.4).ignoresSafeArea())
            
            ZStack {
                Form {
                    Section("Кастомизация интерфейса") {
                        Toggle("Поворот меню", isOn: $rotatesWhenExpands)
                    }
                    
                    Section("Управление данными") {
                        Button(role: .destructive, action: { showingConfirmation = true }, label: {
                            HStack(spacing: 10) {
                                Spacer()
                                Image(systemName: "trash")
                                Text("Очистить кэш")
                                Spacer()
                            }
                        })
                    }
                }
                .scrollDisabled(true)
                
                if isAlertClearCacheVisible {
                    VisualEffectView(effect: UIBlurEffect(style: .light))
                        .ignoresSafeArea(edges: .all)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .sensoryFeedback(.success, trigger: isAlertClearCacheVisible)
        .confirmationDialog("Очистить весь кэш", isPresented: $showingConfirmation, actions: {
            Button("Очистить весь кэш", role: .destructive, action: { settingsViewModel.clearCookiesAndCache() })
            
            Button("Отмена", role: .cancel, action: {})
        }, message: {
            Text("Все сохранённые документы и закладки останутся на устройстве, будет очищен только кэш")
        })
        .toast(isPresenting: $isAlertClearCacheVisible, duration: 1.5, tapToDismiss: true) {
            AlertToast(type: .complete(.green), title: "Кэш успешно очищен")
        }
        .onReceive(settingsViewModel.isAlertClearCacheVisible.receive(on: RunLoop.main), perform: { value in
            isAlertClearCacheVisible = value
        })
    }
}
