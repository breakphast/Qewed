//
//  AddSongView.swift
//  Qewed
//
//  Created by Desmond Fitch on 2/7/22.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AddSongView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var addSongViewModel: AddSongViewModel
    
    @State var image: UIImage?
    @State var title = ""
    @State var artist = ""
    @State var genre = ""
    @State var userDescription = ""
    @State var user = ""
    @State var appleMusic = ""
    @State var spotify = ""
    @State var youtube = ""
    @State var subgenre = ""
    
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @State var songPosted = false
    
    var testImage: UIImage? = nil
    
    @State var showSubgenre = false
    
    @State var showPicker = false
    
    @State var fieldError = false
    
    let variants: [SymbolVariants] = [.fill, .none]
    
    let genres = ["Pop", "Hip-Hop", "R&B", "Rock", "Electronic", "Alternative", "Country", "Soundtrack"]
    
    private let songService = SongService()
    
    var body: some View {
        ZStack {
            Color("mygray")
                .ignoresSafeArea()
            
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        VStack {
                            Image("lightdraw")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                            Text("Add a song!")
                                .font(.largeTitle.bold())
                                .padding(.bottom, 20)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            VStack(alignment: .leading) {
                                Text("Song Info")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)

                                customTextField(text: $title, entry: "Title")
                                    .padding(20)
                                    .font(.body.bold())
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(15)
                                    .disableAutocorrection(true)
                                customTextField(text: $artist, entry: "Artist")
                                    .padding(20)
                                    .font(.body.bold())
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(15)
                                    .disableAutocorrection(true)

                                genreMenu

                                if showSubgenre {
                                    customTextField(text: $subgenre, entry: "Subgenre")
                                        .padding(20)
                                        .font(.body.bold())
                                        .frame(maxWidth: .infinity)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(15)
                                        .disableAutocorrection(true)
                                }

                            }
                            .padding(.bottom, 20)

                            Button {
                                showPicker.toggle()
                            } label: {
                                HStack {
                                    if image == nil {
                                        Image(systemName: "photo")
                                            .font(.title)
                                            .foregroundColor(Color("purp"))
                                            .padding(.leading, 20)
                                            .padding(.vertical, 10)
                                    } else {
                                        Image(uiImage: image!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .background(.black.opacity(0.3))
                                            .cornerRadius(10)
                                            .padding(.leading, 20)
                                            .padding(.vertical, 10)
                                    }
                                    Text("Artwork")
                                        .padding(.leading, 10)

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .padding(20)
                                }
                                .foregroundColor(Color("purp"))
                                .font(.body.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.ultraThinMaterial)
                                .cornerRadius(15)
                            }
                            .padding(.bottom, 20)

                            VStack(alignment: .leading) {
                                Text("Links")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)

                                customTextField(text: $appleMusic, entry: "Apple Music (optional)")
                                    .padding(20)
                                    .font(.body.bold())
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(15)
                                    .disableAutocorrection(true)
                                customTextField(text: $spotify, entry: "Spotify (optional)")
                                    .padding(20)
                                    .font(.body.bold())
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(15)
                                    .disableAutocorrection(true)
                                customTextField(text: $youtube, entry: "YouTube (optional)")
                                    .padding(20)
                                    .font(.body.bold())
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(15)
                                    .disableAutocorrection(true)
                            }
                            .padding(.bottom, 20)
                        }
                        .padding(.horizontal, 20)

                        if fieldError {
                            Text("FILL REQUIRED FIELDS")
                                .fontWeight(.bold)
                        }

                        Button {
                            if viewModel.userSession == nil {
                                
                            } else {
                                if title != "" && artist != "" && image != nil {
                                    addSongViewModel.persistImageToStorage(image: self.image, artist: self.artist, title: self.title, userDescription: self.userDescription, genre: self.genre, appleMusic: self.appleMusic, spotify: self.spotify, youtube: self.youtube, user: viewModel.currentUser!.username, userFullName: viewModel.currentUser!.fullName)
                                    
                                    self.songPosted.toggle()
                                    self.selectedTab = .home
                                } else {
                                    fieldError = true
                                }
                            }
                        } label: {
                            Text("Post Song")
                                .foregroundColor(title != "" && artist != "" && image != nil ? .white : .white.opacity(0.2))
                                .font(.title3.bold())
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .background(title != "" && artist != "" && image != nil ? Color("purp") : .secondary.opacity(0.5))
                                .strokeStyle(cornerRadius: 15)
                                .cornerRadius(15)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 88)
                    }
                }
                .sheet(isPresented: $showPicker) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
                }
            }
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: 20)
            })
        }
    }
    var genreMenu: some View {
        Menu {
            ForEach(genres, id: \.self) { genre in
                Button {
                    self.genre = genre
                } label: {
                    Text(genre)
                }
            }
            
            Button("Subgenre") {
                showSubgenre.toggle()
            }
                
        } label: {
            HStack {
                Text(self.genre == "" ? "Genre" : genre)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding(20)
            .foregroundColor(Color("purp"))
            .font(.body.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
        }
    }
}

struct AddSongView_Previews: PreviewProvider {
    static var previews: some View {
        AddSongView()
    }
}
