//
//  ErrorView.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 29.03.24.
//

import SwiftUI

struct ErrorView: View {
    let errorModel: ErrorModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Произошла ошибка!")
                    .font(.title)
                    .padding(.bottom)
                Text(errorModel.error.localizedDescription)
                    .font(.headline)
                Text(errorModel.guidance)
                    .font(.caption)
                    .padding(.top)
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.1).ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Отклонить") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    enum SampleError: Error {
        case errorRequired
    }
    
    return ErrorView(errorModel: ErrorModel(error: SampleError.errorRequired,
                         guidance: "Вы можете безопасно проигнорировать эту ошибку"))
}
