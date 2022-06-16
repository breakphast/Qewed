//
//  Home.swift
//  Qewed
//
//  Created by Desmond Fitch on 2/7/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct Home: View {
    @State var filterShow = false
    @State var filteredSongs = false
    @ObservedObject var vm: HomeViewModel
    
    let genres = ["All", "Pop", "Hip-Hop", "R&B", "Rock", "Electronic", "Alternative", "Country", "Soundtrack"]
    let uid = Auth.auth().currentUser?.uid
    
    @State var filter = "All"
    
    init(user: User) {
        self.vm = HomeViewModel(user: user)
    }
    
    var body: some View {
        ZStack {
            Color("mygray")
                .ignoresSafeArea()
            
            VStack {
                if filterShow {
                    Menu {
                        ForEach(self.genres, id: \.self) { genre in
                            Button {
                                withAnimation {
                                    if genre != "All" {
                                        vm.fetchFilteredSongs(genre: genre) { bool in
                                            self.filter = genre
                                            self.filteredSongs = bool
                                        }
                                    } else {
                                        self.filter = genre
                                        self.filteredSongs = false
                                    }
                                }
                            } label: {
                                Text(genre)
                            }
                        }
                    } label: {
                        Text(filter)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: 300)
                            .background(Color("purp"), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 10)
                            
                    }
                }
                
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        if self.filteredSongs == true {
                            ForEach(vm.filteredSongs.reversed()) { song in
                                VStack {
                                    ListedSongView(song: song, user: vm.user)
                                }
                            }
                        } else if filterShow == false || self.filteredSongs == false {
                            ForEach(vm.songs.reversed()) { song in
                                
                                VStack {
                                    ListedSongView(song: song, user: vm.user)
                                }
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(maxHeight: .infinity, alignment: .top)
                    .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 100)
                    }
                }
            }
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: 75)
            })
            .overlay(NavigationBar(filterShow: $filterShow, filteredSongs: $filteredSongs))
        }
    }
}
