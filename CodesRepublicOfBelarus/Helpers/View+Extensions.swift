//
//  View+Extensions.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 25.03.24.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> Void) -> some View {
        self
            .overlay {
                GeometryReader { geometry in
                    let minX = geometry.frame(in: .scrollView(axis: .horizontal)).minX
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
    
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat) -> some View {
        ZStack {
            self
                .foregroundStyle(.gray)
            
            self
                .symbolVariant(.fill)
                .mask {
                    GeometryReader { geometry in
                        let size = geometry.size
                        let capsuleWidth = size.width / CGFloat(TabModel.allCases.count)
                        
                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(x: tabProgress * (size.width - capsuleWidth))
                    }
                }
        }
    }
    
    @ViewBuilder
    func customContextMenu(code: CodeModel, toggleIsFlipped: @escaping () -> Void, isFlipped: Bool, isSaved: Bool) -> some View {
        self
            .contextMenu {
                Button(action: toggleIsFlipped) {
                    Label(!isFlipped ? "Посмотреть описание" : "Посмотреть название", systemImage: "list.bullet.clipboard.fill")
                }
                if isSaved {
                    Button(role: .destructive, action: { code.html = nil }) {
                        Label("Удалить из сохранённых", systemImage: "trash")
                    }
                }
            }
    }
}

extension Bool: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        if lhs && !rhs {
            return true
        } else if !lhs && rhs {
            return false
        } else {
            return false
        }
    }
}
