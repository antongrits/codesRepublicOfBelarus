//
//  CodesScrollView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 27.03.24.
//

import SwiftUI
import SwiftData

struct CodesScrollView: View {
    @Query(animation: .spring) var codes: [CodeModel]
    @State var searchString = ""
    @Binding var selectedTab: TabModel?
    @FocusState private var textfieldFocused: Bool
    
    var filteredArticles: [CodeModel] {
        guard !searchString.isEmpty else { return codes }
        return codes.filter({ $0.name.localizedCaseInsensitiveContains(searchString) })
    }
    
    var body: some View {
        LazyHStack(spacing: 0) {
            ScrollView(.vertical) {
                ZStack(alignment: .trailing) {
                    TextField("Поиск по названию...", text: $searchString)
                        .focused($textfieldFocused)
                        .onLongPressGesture(minimumDuration: 0.0) {
                            textfieldFocused = true
                        }
                        .autocorrectionDisabled()
                        .font(.system(size: 15))
                        .padding(8)
                        .padding(.trailing, 30)
                        .padding(.leading, 5)
                        .background(in: .rect(cornerRadius: 15))
                    
                    if searchString != "" {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .onTapGesture {
                                searchString = ""
                                textfieldFocused = false
                            }
                            .padding(7)
                            .padding(.trailing, 3)
                    }
                    
                }
                .padding(.horizontal, 15)
                .padding(.bottom, -5)
                
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                    ForEach(filteredArticles, id: \.id) { code in
                        CodeView(
                            codeModel: code,
                            color: Color(
                                "myLightPurpleColor"
                            ),
                            isTrue: 360,
                            isFalse: 0,
                            isSaved: false
                        )
                    }
                }
                .padding(15)
            }
            .id(TabModel.all)
            .scrollIndicators(.hidden)
            .containerRelativeFrame(.horizontal)
            .scrollClipDisabled()
            .mask {
                Rectangle()
                    .padding(.bottom, -100)
            }
            
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                    ForEach(codes.filter({ $0.html != nil }), id: \.id) { code in
                        CodeView(
                            codeModel: code,
                            color: Color(
                                "myDarkPurpleColor"
                            ),
                            isTrue: 360,
                            isFalse: 0,
                            isSaved: true
                        )
                    }
                }
                .padding(15)
            }
            .id(TabModel.saved)
            .scrollIndicators(.hidden)
            .containerRelativeFrame(.horizontal)
            .scrollClipDisabled()
            .mask {
                Rectangle()
                    .padding(.bottom, -100)
            }
            .overlay {
                if codes.filter({ $0.html != nil }).isEmpty {
                    Text("Список сохранённых документов пуст...")
                        .font(.system(size: 18))
                        .scrollDisabled(true)
                        .padding(.bottom, 100)
                        .padding(.horizontal, 10)
                }
            }
        }
        .onChange(of: selectedTab) {
            switch selectedTab {
            case .all:
                if searchString != "" {
                    textfieldFocused = true
                }
            case .saved:
                textfieldFocused = false
            case nil:
                return
            }
        }
        .onDisappear {
            textfieldFocused = false
        }
    }
    
    init(sort: [SortDescriptor<CodeModel>], selectedTab: Binding<TabModel?>) {
        _codes = Query(sort: sort, animation: .spring)
        _selectedTab = selectedTab
    }
}
