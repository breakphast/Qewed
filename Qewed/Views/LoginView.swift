//
//  LoginView.swift
//  Qewed
//
//  Created by Desmond Fitch on 3/23/22.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var fullName = ""
    
    @State private var loginMode = true
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        signInView
    }
    
    var signInView: some View {
        VStack {
            NavigationLink(destination: ProfilePhotoSelectorView(), isActive: $authVM.didAuthenticateUser, label: { })
            
            Image("darkWelcome")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            VStack(spacing: 8) {
                Text("Hello!")
                    .font(.largeTitle.bold())
                Text("Welcome to Qewed.")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            .padding()
            
            VStack(spacing: 16) {
                customTextField(text: $email, entry: "Email")
                    .padding(20)
                    .font(.body.bold())
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                if !loginMode {
                    customTextField(text: $fullName, entry: "Display Name")
                        .padding(20)
                        .font(.body.bold())
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .disableAutocorrection(true)
                    
                    customTextField(text: $username, entry: "Username")
                        .padding(20)
                        .font(.body.bold())
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                
                customSecureField(text: $password, entry: "Password")
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            .padding(20)
            
            signInButton
            
            HStack(spacing: 4) {
                Text(loginMode ? "Not a member?" : "Already a member?")
                    .fontWeight(.semibold)
                Text(loginMode ? "Register Now" : "Sign In")
                    .foregroundColor(Color("purp"))
                    .fontWeight(.bold)
                    .onTapGesture {
                        loginMode.toggle()
                    }
            }
            
            Spacer()
        }
        .padding(.top, 20)
    }
    var signInButton: some View {
        Button {
            if loginMode {
                authVM.login(withEmail: email, password: password, username: username)
            } else {
                authVM.register(withEmail: email, password: password, username: username, fullName: fullName)
            }
        } label: {
            Text(loginMode ? "Login" : "Create Account")
                .foregroundColor(.white)
                .font(.title3.bold())
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color("purp"))
                .strokeStyle(cornerRadius: 15)
                .cornerRadius(15)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
