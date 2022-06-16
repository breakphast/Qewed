//
//  QewedApp.swift
//  Qewed
//
//  Created by Desmond Fitch on 2/3/22.
//

import SwiftUI
import Firebase
@main
struct QewedApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var addSongViewModel = AddSongViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(viewModel)
            .environmentObject(addSongViewModel)
        }
    }
}
