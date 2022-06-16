//
//  NavigationBar.swift
//  Qewed
//
//  Created by Desmond Fitch on 2/3/22.
//

import SwiftUI

struct NavigationBar: View {
    @Binding var filterShow: Bool
    @Binding var filteredSongs: Bool
    
    @AppStorage("selectedTab") var selectedTab: Tab = .account
    
    var body: some View {
        ZStack {
            Color("mygray")
                .ignoresSafeArea()
            HStack {
                HStack(spacing: 4) {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .shadow(color: .gray.opacity(0.3), radius: 7, x: 0, y: 1)
                    
                    Text("Qewed")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color("purp"))
                }
                .padding(.leading, 20)
                Spacer()
                
                if self.selectedTab == .home {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.title.bold())
                        .foregroundColor(Color("purp"))
                        .symbolVariant(filterShow ? .fill : .none)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                filterShow.toggle()
                                if self.filteredSongs == true {
                                    filteredSongs = false
                                }
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(height: 70)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
