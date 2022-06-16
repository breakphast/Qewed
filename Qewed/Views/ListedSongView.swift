//
//  ListedSongView.swift
//  Qewed
//
//  Created by Desmond Fitch on 5/22/22.
//

import SwiftUI
import FirebaseAuth
import Firebase
import SDWebImageSwiftUI
import Kingfisher

struct ListedSongView: View {
    let variants: [SymbolVariants] = [.fill, .none]
    let genres = ["Pop", "Hip-Hop", "Rock", "Electronic"]
    let uid = Auth.auth().currentUser?.uid

    @ObservedObject var viewModel: SongViewModel
    @ObservedObject var listedViewModel: ListedSongViewModel
    
    init(song: Song, user: User) {
        self.viewModel = SongViewModel(song: song)
        self.listedViewModel = ListedSongViewModel(user: user, song: song)
    }
    
    @State var artwork = UIImage()
    @State private var showingUserProfile = false
    @State private var showSongView = false
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("@\(viewModel.song.songUser?.username ?? "")")
                    .font(.caption2.bold())
                    .foregroundStyle(Color("purp"))

                HStack {
                    singleSongInfo

                    Spacer()

                    heartAndMenu
                }
                RoundedRectangle(cornerRadius: 0.5)
                    .frame(height: 1)
                    .foregroundStyle(.gray.opacity(0.3))
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            }
            .padding(.horizontal, 20)
        }
        .contentShape(Rectangle())
        .contextMenu {
            if viewModel.song.userID == uid {
                Button {
                    listedViewModel.deleteSong(song: viewModel.song)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                
                if viewModel.song.appleMusic != "" {
                    Button {
                        openURL(URL(string: viewModel.song.appleMusic)!)
                    } label: {
                        HStack {
                            Text("Apple Music")
                            Link(destination: URL(string: viewModel.song.appleMusic)!) {
                                 Image("apple_music")
                             }
                        }
                    }
                }
                
                if viewModel.song.spotify != "" {
                    Button {
                        openURL(URL(string: viewModel.song.spotify)!)
                    } label: {
                        HStack {
                            Text("Spotify")
                            Link(destination: URL(string: viewModel.song.spotify)!) {
                                 Image("spotify")
                             }
                        }
                    }
                }
                
                if viewModel.song.youtube != "" {
                    Button {
                        openURL(URL(string: viewModel.song.youtube)!)
                    } label: {
                        HStack {
                            Text("Youtube")
                            Link(destination: URL(string: viewModel.song.youtube)!) {
                                 Image("youtube")
                             }
                        }
                    }
                }
                
            } else {
                Button {
                    self.showingUserProfile.toggle()
                } label: {
                    Label("@\(viewModel.song.user)", systemImage: "person")
                }
                
                if viewModel.song.appleMusic != "" {
                    Button {
                        openURL(URL(string: viewModel.song.appleMusic)!)
                    } label: {
                        HStack {
                            Text("Apple Music")
                            Link(destination: URL(string: viewModel.song.appleMusic)!) {
                                 Image("apple_music")
                             }
                        }
                    }
                }
                
                if viewModel.song.spotify != "" {
                    Button {
                        openURL(URL(string: viewModel.song.spotify)!)
                    } label: {
                        HStack {
                            Text("Spotify")
                            Link(destination: URL(string: viewModel.song.spotify)!) {
                                 Image("spotify")
                             }
                        }
                    }
                }
                
                if viewModel.song.youtube != "" {
                    Button {
                        openURL(URL(string: viewModel.song.youtube)!)
                    } label: {
                        HStack {
                            Text("Youtube")
                            Link(destination: URL(string: viewModel.song.youtube)!) {
                                 Image("youtube")
                             }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingUserProfile, onDismiss: nil) {
            ProfileView(user: viewModel.song.songUser!, currentUserProfile: false)
        }
        .fullScreenCover(isPresented: $showSongView, onDismiss: nil) {
            SongView(song: viewModel.song, currentUser: self.uid == viewModel.song.userID ? true : false)
        }
    }
    var singleSongInfo: some View {
        HStack {
            WebImage(url: URL(string: viewModel.song.albumArt))
                .resizable()
                .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .frame(width: 60, height: 60)
                .strokeStyle(cornerRadius: 15)

            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.song.title)
                        .foregroundStyle(.primary)
                        .font(.body.bold())
                        .lineLimit(1)
                    Text(viewModel.song.artist)
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                }
                Text(viewModel.song.genre)
                    .padding(5)
                    .foregroundColor(Color("purp"))
                    .font(.caption2.bold())
                    .background(.thinMaterial)
                    .cornerRadius(5)
                    .padding(.top, 1)
            }
        }
    }
    var heartAndMenu: some View {
        HStack(spacing: 4) {
            Button {
                viewModel.likeSong()
            } label: {
                Image(systemName: viewModel.song.didLike == true ? "heart.fill" : "heart")
                    .foregroundStyle(Color("purp"))
                    .font(.title2.bold())
                    .onTapGesture {
                        viewModel.song.didLike ?? false ?
                        viewModel.unlikeSong() : viewModel.likeSong()
                    }
            }
        }
    }
}
