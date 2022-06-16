//
//  UserRowView.swift
//  Qewed
//
//  Created by Desmond Fitch on 3/25/22.
//

import SwiftUI
import Kingfisher

struct UserRowView: View {
    @Environment(\.colorScheme) var colorScheme

    let user: User
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                
                KFImage(URL(string: user.imageProfileURL))
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .overlay(Circle().stroke(LinearGradient(colors: [Color("purp"), colorScheme == .light ? .black : .white], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(user.fullName)")
                        .font(.subheadline).bold()
                        .foregroundColor(.primary)
                    Text("@\(user.username)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("purp"))
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            Divider()
                .padding(.horizontal, 20)
        }
    }
}
