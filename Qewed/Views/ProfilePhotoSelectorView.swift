//
//  ProfilePhotoSelectorView.swift
//  Qewed
//
//  Created by Desmond Fitch on 3/23/22.
//

import SwiftUI

struct ProfilePhotoSelectorView: View {
    @State private var showingImagePicker = false
    @State private var showingUserView = false
    
    @State var img: UIImage?
    @State private var profileImage: Image?
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if img == nil {
                Text("Choose Profile Photo")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
            }
            Button {
                showingImagePicker.toggle()
            } label: {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .modifier(ProfileImageModifier())
                } else {
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .background(Circle().foregroundColor(Color("purp")))
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                }
            }
            
            if let img = img {
                Button {
                    viewModel.uploadProfileImage(img)
                } label: {
                    Text("Continue")
                        .padding(.horizontal, 60)
                        .padding(.vertical, 15)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(Color("purp"))
                        .clipShape(Capsule())
                }
            }
        }
        .fullScreenCover(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $img)
        }
    }
    
    func loadImage() {
        guard let img = img else { return }
        
        profileImage = Image(uiImage: img)
    }
}

private struct ProfileImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(.systemBlue))
            .scaledToFill()
            .frame(width: 75, height: 75)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color("purp"), lineWidth: 3))
    }
}

struct ProfilePhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoSelectorView()
    }
}
