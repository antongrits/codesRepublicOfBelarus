//
//  ContentView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 23.03.24.
//

import SwiftUI
import SwiftData

struct CodesView: View {
    @State private var selectedTab: TabModel?
    @State private var tabProgress: CGFloat = 0.0
    @State private var sortOrder = [SortDescriptor(\CodeModel.isChosen, order: .reverse), SortDescriptor(\CodeModel.name)]
    @Binding var showMenu: Bool
    
    var safeArea: UIEdgeInsets
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 15) {
                HeaderView(sortOrder: $sortOrder, showMenu: $showMenu)
                
                CustomTabBarView(selectedTab: $selectedTab, tabProgress: $tabProgress)
                
                    GeometryReader { geometry in
                        let size = geometry.size
                        
                        ScrollView(.horizontal) {
                            CodesScrollView(sort: sortOrder, selectedTab: $selectedTab)
                                .scrollTargetLayout()
                                .offsetX { value in
                                    let progress = -value / (size.width * CGFloat(TabModel.allCases.count - 1))
                                    
                                    tabProgress = max(min(progress, 1), 0)
                                }
                        }
                        .scrollPosition(id: $selectedTab)
                        .scrollIndicators(.hidden)
                        .scrollTargetBehavior(.paging)
                        .scrollClipDisabled()
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, safeArea.top)
        }
    }
}
