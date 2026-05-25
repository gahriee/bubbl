//
//  bubblApp.swift
//  bubbl
//
//  Created by Eli on 5/26/26.
//

import SwiftUI
import FirebaseCore

@main
struct bubblApp: App {
    @StateObject private var appState: AppState

    init() {
        FirebaseApp.configure()
        let container = DIContainer()
        _appState = StateObject(wrappedValue: AppState(container: container))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
