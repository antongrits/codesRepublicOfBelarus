//
//  CustomTabBarView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 27.03.24.
//

import SwiftUI

struct CustomTabBarView: View {
    @Environment(\.colorScheme) private var scheme
    @Binding var selectedTab: TabModel?
    @Binding var tabProgress: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabModel.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Image(systemName: tab.systemImage)
                    Text(tab.rawValue)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
            }
        }
        .tabMask(tabProgress)
        .background {
            GeometryReader { geometry in
                let size = geometry.size
                let capsuleWidth = size.width / CGFloat(TabModel.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black.opacity(0.4) : .white)
                    .frame(width: capsuleWidth)
                    .offset(x: tabProgress * (size.width - capsuleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
}
