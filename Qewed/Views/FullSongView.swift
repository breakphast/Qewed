//
//  SongVu.swift
//  Qewed
//
//  Created by Desmond Fitch on 3/27/22.
//

import SwiftUI
import FirebaseAuth
import Firebase
import SDWebImageSwiftUI
import Kingfisher

struct SongView: View {
    @State private var filled = false
    @State private var followed = false
    
    let buttons = ["Profile", "Follow"]
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: SongViewModel
    
    @State private var clickedLike = false
    
    let currentUser: Bool
    
    init(song: Song, currentUser: Bool) {
        self.viewModel = SongViewModel(song: song)
        self.currentUser = currentUser
    }
    
    var body: some View {
        ZStack {
            VStack {
                songCard
                
                Text("Hi")
            }
            
            closeSongButton
            
            TabBar()
        }
        .background(
            .ultraThinMaterial
        )
    }
    
    var songInfo: some View {
        VStack {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(viewModel.song.title)
                            .font(.title2.weight(.bold))
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: viewModel.song.didLike == true ? "heart.fill" : "heart")
                            .foregroundStyle(Color("purp"))
                            .font(.title.bold())
                            .onTapGesture {
                                viewModel.song.didLike ?? false ?
                                viewModel.unlikeSong() : viewModel.likeSong()
                            }
                    }
                    
                    Text(viewModel.song.artist)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                if viewModel.song.userDescription != "" {
                    Text(viewModel.song.userDescription)
                        .font(.body)
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                        .lineSpacing(5)
                }
                
                HStack(spacing: 4) {
                    if viewModel.song.appleMusic != "" {
                        Image("apple_music")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                    }
                    
                    if viewModel.song.spotify != "" {
                        Image("spotify")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                    }
                    
                    if viewModel.song.youtube != "" {
                        Image("youtube")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                    }
                }
                
                Divider()
                
                HStack {
                    HStack(spacing: 12) {
                        
                        KFImage(URL(string: viewModel.song.songUser?.imageProfileURL ?? ""))
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .overlay(Circle().stroke(LinearGradient(colors: [Color("purp"), colorScheme == .light ? .black : .white], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(viewModel.song.songUser?.fullName ?? "")")
                                .font(.subheadline).bold()
                                .foregroundColor(.primary)
                            Text("@\(viewModel.song.songUser?.username ?? "")")
                                .font(.subheadline).bold()
                                .foregroundColor(Color("purp"))
                        }
                    }
                    
                    Spacer()
                    
                    if followed == false {
                        Text(self.currentUser == false ? "Follow" : "Edit Song")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(width: 120)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color("purp"), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .onTapGesture {
                                withAnimation {
                                    followed.toggle()
                                }
                            }
                    } else {
                        HStack {
                            Text("Followed")
                                .fontWeight(.bold)
                            Image(systemName: "checkmark")
                        }
                        .foregroundColor(Color("purp"))
                        .frame(width: 120)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                followed.toggle()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(maxHeight: .infinity)
        .background(Color.mint)
    }
    
    var songCard: some View {
        WebImage(url: URL(string: viewModel.song.albumArt))
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: getRect().height * 0.45, alignment: .top)
            .edgesIgnoringSafeArea(.top)
    }
    
    var img: some View {
        WebImage(url: URL(string: viewModel.song.albumArt))
            .resizable()
            .scaledToFit()
            .frame(width: 1000, height: 1000)
    }
    
    var closeSongButton: some View {
        Button {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                dismiss()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.body.bold())
                .foregroundColor(Color("purp"))
                .padding(8)
                .background(Color("mygray"), in: Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(20)
        .offset(y: 20)
        .ignoresSafeArea()
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}




struct SongView2: View {
    @State private var filled = false
    @State private var followed = false
    @State private var clickedLike = false

    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var viewModel: SongViewModel

    let currentUser: Bool

    init(song: Song, currentUser: Bool) {
        self.viewModel = SongViewModel(song: song)
        self.currentUser = currentUser
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 40) {
                    songCard
                    
                    songInfo
                }
                .ignoresSafeArea()
                
                closeSongButton
            }
        }
    }
    
    var songCard: some View {
        WebImage(url: URL(string: viewModel.song.albumArt))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: 800)
            .ignoresSafeArea()
    }
    
    var songInfo: some View {
        VStack {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(viewModel.song.title)
                            .font(.title2.weight(.bold))
                            .lineLimit(1)
                        Spacer()
                        Image(systemName: viewModel.song.didLike == true ? "heart.fill" : "heart")
                            .foregroundStyle(Color("purp"))
                            .font(.title.bold())
                            .onTapGesture {
                                viewModel.song.didLike ?? false ?
                                viewModel.unlikeSong() : viewModel.likeSong()
                            }
                    }
                    
                    Text(viewModel.song.artist)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                if viewModel.song.userDescription != "" {
                    Text(viewModel.song.userDescription)
                        .font(.body)
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                        .lineSpacing(5)
                }
                
                HStack(spacing: 4) {
                    if viewModel.song.appleMusic != "" {
                        Image("apple_music")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                    }
                    
                    if viewModel.song.spotify != "" {
                        Image("spotify")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                    }
                    
                    if viewModel.song.youtube != "" {
                        Image("youtube")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                    }
                }
                
                Divider()
                
                HStack {
                    HStack(spacing: 12) {
                        
                        KFImage(URL(string: viewModel.song.songUser?.imageProfileURL ?? ""))
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .overlay(Circle().stroke(LinearGradient(colors: [Color("purp"), colorScheme == .light ? .black : .white], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(viewModel.song.songUser?.fullName ?? "")")
                                .font(.subheadline).bold()
                                .foregroundColor(.primary)
                            Text("@\(viewModel.song.songUser?.username ?? "")")
                                .font(.subheadline).bold()
                                .foregroundColor(Color("purp"))
                        }
                    }
                    
                    Spacer()
                    
                    if followed == false {
                        Text(self.currentUser == false ? "Follow" : "Edit Song")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(width: 120)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color("purp"), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .onTapGesture {
                                withAnimation {
                                    followed.toggle()
                                }
                            }
                    } else {
                        HStack {
                            Text("Followed")
                                .fontWeight(.bold)
                            Image(systemName: "checkmark")
                        }
                        .foregroundColor(Color("purp"))
                        .frame(width: 120)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                followed.toggle()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    var closeSongButton: some View {
        Button {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                dismiss()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.body.bold())
                .foregroundColor(Color("purp"))
                .padding(8)
                .background(Color("mygray"), in: Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(20)
        .offset(y: 20)
        .ignoresSafeArea()
    }
}
