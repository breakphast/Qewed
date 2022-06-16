//
//  TabBar.swift
//  Qewed
//
//  Created by Desmond Fitch on 2/3/22.
//

import SwiftUI

struct TabBar: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geo in
            let hasHomeIndicator = geo.safeAreaInsets.bottom > 20
            
            HStack {
                ForEach(tabItems) { item in
                    Button {
                        selectedTab = item.tab
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: item.icon)
                                .symbolVariant(selectedTab == item.tab ? .fill : .none)
                                .foregroundColor(selectedTab == item.tab ? Color("purp") : .secondary)
                                .font(.title2)
                            
                            Text(item.name)
                                .font(.caption2)
                                .fontWeight(selectedTab == item.tab ? .bold : .none)
                                .foregroundColor(selectedTab == item.tab ? Color("purp") : .secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, 12)
            .padding(.horizontal, 10)
            .frame(height: hasHomeIndicator ? 88 : 65, alignment: .top)
            .background(.ultraThinMaterial)
            .mask(Rectangle())
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            .shadow(color: colorScheme == .light ? .black.opacity(0.2) : .white.opacity(0.2), radius: 2, x: 0, y: -1)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
