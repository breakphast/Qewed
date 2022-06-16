//
//  ProfileTestView.swift
//  Qewed
//
//  Created by Desmond Fitch on 2/23/22.
//

import SwiftUI
import FirebaseAuth
import Firebase
import SDWebImageSwiftUI
import Kingfisher

struct ProfileView: View {
    @State private var selectedFilter: SongFilterViewModel = .allSongs
    @State private var likesActive: Bool = false
    @State private var showSongView = false
    @State private var editProfile = false
    @State private var showingUserProfile = false
    
    @State private var showingImagePicker = false
    @State var img: UIImage?
    @State private var profileImage: Image?
    
    @State private var username = ""
    @State private var fullName = ""
    
    @State private var blurRadius: CGFloat = 0
    @State private var imageSize: CGFloat = 75
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var viewModel: ProfileViewModel
    
    init(user: User, currentUserProfile: Bool) {
        self.viewModel = ProfileViewModel(user: user)
        self.currentUserProfile = currentUserProfile
    }
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @Environment(\.dismiss) var dismiss
    
    let currentUserProfile: Bool
    
    let columns = [
        GridItem(.adaptive(minimum: 250)),
        GridItem(.adaptive(minimum: 250))
    ]
    
    var body: some View {
        ZStack {
            Color("mygray")
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 8) {
                    basicInfo
                    
                    profileStats

                    editAndLikesStack
                    
                    ScrollView(showsIndicators: false) {
                        songs
                    }
                    .frame(maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity)
                .safeAreaInset(edge: .bottom, content: {
                    Color.clear.frame(height: 88)
                })
                .padding(20)
            }
            .padding(.top, 10)
        }
        .overlay {
            if self.currentUserProfile == true {
                if self.editProfile == true {
                    doneButton
                } else {
                    signOutButton
                }
            } else {
                closeProfileButton
            }
        }
    }
    
    var songs: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(selectedFilter == .allSongs ? "\(viewModel.user.fullName.components(separatedBy: " ").first ?? "All")'s Songs" : "Likes")
                .font(.title2.bold())
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.songs(forFilter: self.selectedFilter)) { song in
                    songCard(title: song.title, artist: song.artist, albumArt: song.albumArt, song: song, currentUserProfile: currentUserProfile, selectedFilter: self.$selectedFilter, viewModel: self.viewModel)
                }
            }
        }
        .padding(.top, 16)
    }
    
    var basicInfo: some View {
        VStack(alignment: .leading) {
            HStack {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 75, height: 75)
                        .overlay(Circle().stroke(LinearGradient(colors: [Color("purp"), colorScheme == .light ? .black : .white], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
                        .shadow(color: self.editProfile == true ? Color("purple") : .clear, radius: 10, x: 10, y: 10)
                        .onTapGesture {
                            self.showingImagePicker.toggle()
                        }
                } else {
                    KFImage(URL(string: viewModel.user.imageProfileURL))
                        .resizable()
                        .scaledToFill()
                        .mask(Circle())
                        .frame(width: self.imageSize, height: self.imageSize)
                        .background(
                            Circle()
                            .foregroundColor(self.editProfile == true ? Color("purp") : .clear)
                        )
                        .overlay(Circle().stroke(LinearGradient(colors: [Color("purp"), colorScheme == .light ? .black : .white], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
                        .onTapGesture {
                            if self.editProfile == true {
                                self.showingImagePicker.toggle()
                            }
                        }
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                if self.editProfile == true {
                    VStack {
                        customTextField(text: $username, entry: "\(viewModel.user.username)")
                            .padding(10)
                            .font(.body.bold())
                            .frame(maxWidth: 200, alignment: .leading)
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .foregroundColor(self.editProfile == true ? Color("purp") : .clear))
                                .background(Color("purp"), in: RoundedRectangle(cornerRadius: 15, style: .continuous)
                                )
                            .background(Color("purp").opacity(0.5), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        customTextField(text: $fullName, entry: "\(viewModel.user.fullName)")
                            .padding(10)
                            .font(.body.bold())
                            .frame(maxWidth: 200, alignment: .leading)
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                .foregroundColor(self.editProfile == true ? Color("purp") : .clear))
                                .background(Color("purp"), in: RoundedRectangle(cornerRadius: 15, style: .continuous)
                                )
                            .background(Color("purp").opacity(0.5), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .disableAutocorrection(true)
                    }
                } else {
                    Text("\(viewModel.user.fullName)")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                    
                    Text("@\(viewModel.user.username)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("purp"))
                }
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fullScreenCover(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $img)
        }
    }
    
    var followButton: some View {
        Text(viewModel.user.doesFollow == true ? "Following" : "Follow")
            .foregroundColor(.white)
            .font(.headline.bold())
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
            .background(Color("purp"), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    
    var editProfileButton: some View {
        Text("Edit Profile")
            .foregroundColor(.white)
            .font(.headline.bold())
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(self.editProfile == true ? Color("purp") : .clear)
            )
            .background(Color("purp").opacity(self.editProfile ? 0.5 : 1.0), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    
    var closeProfileButton: some View {
        Button {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                dismiss()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.body.bold())
                .foregroundColor(colorScheme == .light ? .white : .black)
                .padding(10)
                .background(Color("purp"), in: Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding()
    }
    
    var signOutButton: some View {
        Button {
            self.username = viewModel.user.username
            authViewModel.signOut()
        } label: {
            Text("Sign Out")
                .foregroundColor(.white)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(10)
                .background(Color("purp"), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding()
    }
    
    var editAndLikesStack: some View {
        HStack {
            Button {
                withAnimation {
                    if viewModel.user.doesFollow == true && viewModel.user.id != Auth.auth().currentUser?.uid {
                        viewModel.unfollowUser()
                        
                    } else if viewModel.user.doesFollow == false && viewModel.user.id != Auth.auth().currentUser?.uid {
                        viewModel.followUser()
                    } else {
                        self.editProfile.toggle()
                    }
                }
            } label: {
                if viewModel.user.id == Auth.auth().currentUser?.uid {
                    editProfileButton
                } else {
                    followButton
                }
            }
            
            Text("Likes")
                .foregroundColor(self.likesActive ? .white : Color("purp"))
                .font(.headline.bold())
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(self.likesActive ? Color("purp") : Color.clear, in: RoundedRectangle(cornerRadius: 10))
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("purp"), lineWidth: 1))
                .onTapGesture {
                    withAnimation {
                        self.likesActive.toggle()
                        
                        if self.selectedFilter == .allSongs {
                            self.selectedFilter = .likes
                        } else {
                            self.selectedFilter = .allSongs
                        }
                    }
                }
        }
        .padding(.top, 12)
        .frame(maxWidth: .infinity)
    }
    
    var profileStats: some View {
        HStack(spacing: 15) {
            HStack(spacing: 3) {
                Text("\(viewModel.followers.count)")
                    .font(.title3.bold())
                Text("Followers")
                    .font(.subheadline)
                    .foregroundColor(.secondary.opacity(0.75))
            }
            
            
            HStack(spacing: 3) {
                Text("\(viewModel.following.count)")
                    .font(.title3.bold())
                Text("Following")
                    .font(.subheadline)
                    .foregroundColor(.secondary.opacity(0.75))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var doneButton: some View {
        Button {
            withAnimation {
                if self.username == "" && self.fullName == "" {
                    self.editProfile.toggle()
                } else if self.username == "" && self.fullName != "" {
                    viewModel.updateFullName(fullName: fullName) { bool in
                        authViewModel.fetchUser()
                        self.editProfile = bool
                    }
                } else if self.username != "" && self.fullName == "" {
                    viewModel.updateUsername(username: username) { bool in
                        authViewModel.fetchUser()
                        self.editProfile = bool
                    }
                } else {
                    viewModel.updateProfile(username: username, fullName: fullName) { bool in
                        authViewModel.fetchUser()
                        self.editProfile = bool
                    }
                }
                
                if let img = img {
                    authViewModel.updateProfileImage(img) {
                        authViewModel.fetchUser()
                        self.editProfile = false
                    }
                }
            }
        } label: {
            Text("Done")
                .foregroundColor(.white)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(self.editProfile == true ? Color("purp") : .clear).blur(radius: self.blurRadius))
                    .background(Color("purp"), in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                    )
                .background(Color("purp"), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding()
    }
    
    func loadImage() {
        guard let img = img else { return }
        
        profileImage = Image(uiImage: img)
    }
}

struct songCard: View {
    let title: String
    let artist: String
    
    let albumArt: String
    
    let song: Song
    
    let currentUserProfile: Bool
    
    @State var showSongView = false
    @State var showUserProfile = false
    @Binding var selectedFilter: SongFilterViewModel
    @ObservedObject var viewModel: ProfileViewModel
    
    @Environment(\.openURL) private var openURL
    
    let uid = Auth.auth().currentUser?.uid
    
    var body: some View {
        ZStack {
            WebImage(url: URL(string: albumArt))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(Color.black.opacity(0.6))
                .mask(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .blur(radius: 4)
            
            VStack(spacing: 4) {
                Text(title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Text(artist)
                    .foregroundColor(Color("purp"))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            .padding(8)
            .multilineTextAlignment(.center)
        }
        .fullScreenCover(isPresented: $showUserProfile) {
            ProfileView(user: song.songUser!, currentUserProfile: false)
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
        .strokeStyle(cornerRadius: 15)
        .cornerRadius(15)
        .contextMenu {
            if uid == song.userID {
                Button {
                    viewModel.deleteSong(song: song)
                    viewModel.fetchUserSongs()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                
                if song.appleMusic != "" {
                    Button {
                        openURL(URL(string: song.appleMusic)!)
                    } label: {
                        HStack {
                            Text("Apple Music")
                            Link(destination: URL(string: song.appleMusic)!) {
                                 Image("apple_music")
                             }
                        }
                    }
                }
                
                if song.spotify != "" {
                    Button {
                        openURL(URL(string: song.spotify)!)
                    } label: {
                        HStack {
                            Text("Spotify")
                            Link(destination: URL(string: song.spotify)!) {
                                 Image("spotify")
                             }
                        }
                    }
                }
                
                if song.youtube != "" {
                    Button {
                        openURL(URL(string: song.youtube)!)
                    } label: {
                        HStack {
                            Text("Youtube")
                            Link(destination: URL(string: song.youtube)!) {
                                 Image("youtube")
                             }
                        }
                    }
                }
                
            } else {
                Button {
                    self.showUserProfile.toggle()
                } label: {
                    Label("@\(song.user)", systemImage: "person")
                }
                
                Button {
                    viewModel.unlikeSong(song: song)
                } label: {
                    Label("Unlike", systemImage: "heart.fill")
                }
                
                if song.appleMusic != "" {
                    Button {
                        openURL(URL(string: song.appleMusic)!)
                    } label: {
                        HStack {
                            Text("Apple Music")
                            Link(destination: URL(string: song.appleMusic)!) {
                                 Image("apple_music")
                             }
                        }
                    }
                }
                
                if song.spotify != "" {
                    Button {
                        openURL(URL(string: song.spotify)!)
                    } label: {
                        HStack {
                            Text("Spotify")
                            Link(destination: URL(string: song.spotify)!) {
                                 Image("spotify")
                             }
                        }
                    }
                }
                
                if song.youtube != "" {
                    Button {
                        openURL(URL(string: song.youtube)!)
                    } label: {
                        HStack {
                            Text("Youtube")
                            Link(destination: URL(string: song.youtube)!) {
                                 Image("youtube")
                             }
                        }
                    }
                }
            }
        }
    }
}
