//
//  ContentView.swift
//  Qewed
//
//  Created by Desmond Fitch on 2/3/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .account
    @State private var showingUserView = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            switch selectedTab {
            case .home:
                Home(user: viewModel.currentUser ?? User(email: "", password: "", username: "", imageProfileURL: "", fullName: "", following: 0, followers: 0))
            case .add:
                AddSongView()
                
            case .explore:
                ExploreView()
                
            case .account:
                VStack(spacing: 30) {
                    if viewModel.userSession == nil {
                        LoginView()
                    } else {
                        if let user = viewModel.currentUser {
                            ProfileView(user: user, currentUserProfile: true)
                        }
                    }
                }
            }
            TabBar()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
