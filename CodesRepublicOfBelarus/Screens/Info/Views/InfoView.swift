//
//  InfoView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 1.05.24.
//

import SwiftUI

struct InfoView: View {
    @Binding var showMenu: Bool
    @State private var showEmail = false
    @State private var email = SupportEmailModel(toAddress: "antongric07@gmail.com", subject: "Support Email", messageHeader: "Пожалуйста, опишите вашу проблему ниже...")
    var safeArea: UIEdgeInsets
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
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
                Text("О приложении")
                    .font(.system(size: 19).bold())
            }
            .padding(10)
            .padding(.bottom, 5)
            .padding(.top, safeArea.top)
            .background(Color.myLightPurple.opacity(0.4).ignoresSafeArea())
            
            Text("""
                Добро пожаловать в наше приложение, посвященное законодательству Республики Беларусь!

                Здесь вы найдете доступ к актуальным правовым документам, собранным с официальных источников.

                Наше приложение обеспечивает удобный и надежный доступ к законодательству, помогая вам быть в курсе всех изменений и обновлений в правовой сфере.

                Мы стремимся предоставить вам лучший опыт использования, чтобы ваша работа с правовыми документами была эффективной и продуктивной.

                Спасибо, что выбрали наше приложение!\u{2764}
                """)
            .font(.system(size: 14))
            .padding(.horizontal, 15)
            
            Button(action: {
                if MailView.canSendMail {
                    showEmail.toggle()
                } else {
                    print("""
                    This device does not support email
                    \(email.body)
                    """
                    )
                }
            }, label: {
                Text("Обратная связь")
                    .foregroundStyle(.black)
            })
            .frame(width: 250, height: 35, alignment: .center)
            .background(.myLightPurple.opacity(0.6))
            .clipShape(.rect(cornerRadius: 15))
            .padding(.top, 50)
            .padding(.horizontal, 15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .sheet(isPresented: $showEmail) {
            MailView(supportEmail: $email) { result in
                switch result {
                case .success:
                    print("Email sent")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
