//
//  AllUsersView.swift
//  Qewed
//
//  Created by Desmond Fitch on 3/23/22.
//

import SwiftUI
import Kingfisher

struct ExploreView: View {
    @ObservedObject var viewModel2 = ExploreViewModel()
    
    var body: some View {
        exploreView
    }
    
    var exploreView: some View {
        ZStack {
            Color("mygray")
                .ignoresSafeArea()
            
            VStack {
                SearchBar(text: $viewModel2.searchText)
                    .padding(10)
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(viewModel2.searchableUsers) { user in
                            NavigationLink {
                                ProfileView(user: user, currentUserProfile: false)
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true)
                                    .padding(.top, -10)
                            } label: {
                                UserRowView(user: user)
                            }
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 75)
                }
            }
            .frame(maxWidth: .infinity)
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: 75)
            })
            .overlay(NavigationBar(filterShow: .constant(false), filteredSongs: .constant(false)))
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
