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

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CodeModel.self, configurations: config)
        let example1 = CodeModel(id: "hk1", name: "Банковский кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 25 октября 2000 г. №441-З", imageName: "bankCode", isChosen: false)
        let example2 = CodeModel(id: "hk2", name: "Бюджетный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 16 июля 2008 г. №412-З", imageName: "budgetCode", isChosen: true, html: "<html>")
        let example3 = CodeModel(id: "hk3", name: "Водный кодекс Республики Беларусь", desc: "Кодекс Республики Беларусь  от 30 апреля 2014 г. №149-З", imageName: "waterCode", isChosen: true, html: "<html>")
        container.mainContext.insert(example1)
        container.mainContext.insert(example2)
        container.mainContext.insert(example3)
        return MotherView()
            .environmentObject(ViewRouter())
            .modelContainer(container)
    } catch {
        fatalError(error.localizedDescription)
    }
}
