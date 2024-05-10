//
//  CodesRepublicOfBelarusApp.swift
//  CodesRepublicOfBelarus
//
//  Created by Aнтон Гриц on 23.03.24.
//

import SwiftUI
import SwiftData

@main
struct CodesRepublicOfBelarusApp: App {
    @StateObject private var errorViewModel = ErrorViewModel()
    @StateObject private var viewRouter = ViewRouter()
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    
    var body: some Scene {
        WindowGroup {
            MotherView()
                .sheet(item: $errorViewModel.errorModel) { error in
                    ErrorView(errorModel: error)
                }
                .preferredColorScheme(.light)
        }
        .environmentObject(viewRouter)
        .environmentObject(errorViewModel)
        .modelContainer(CodesContainer().create(isFirstLaunch: &isFirstLaunch))
    }
}
