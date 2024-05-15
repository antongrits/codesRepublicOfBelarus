//
//  HeaderView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 27.03.24.
//

import SwiftUI

struct HeaderView: View {
    @Binding var sortOrder: [SortDescriptor<CodeModel>]
    @Binding var showMenu: Bool
    
    var body: some View {
        HStack() {
            Button(action: {
                showMenu.toggle()
            }) {
                Image(systemName: showMenu ? "xmark" : "line.3.horizontal.decrease")
                    .contentTransition(.symbolEffect)
            }
            .font(.system(size: 19))
            
            Spacer()

            Menu {
                Picker("Сортировка", selection: $sortOrder) {
                    Text("Сначала избранные")
                        .tag([SortDescriptor(\CodeModel.isChosen, order: .reverse), SortDescriptor(\CodeModel.name)])
                    Text("По алфавиту")
                        .tag([SortDescriptor(\CodeModel.name)])
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
            }
            .padding(.bottom, 2)
            .pickerStyle(.inline)
            .font(.system(size: 18))
            .sensoryFeedback(.selection, trigger: sortOrder)
        }
        .overlay {
            Text("Кодексы Республики Беларусь")
                .font(.system(size: 19).bold())
        }
        .foregroundStyle(.primary)
        .padding(10)
    }
}
