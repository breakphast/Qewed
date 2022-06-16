//
//  Tab.swift
//  Qewed
//
//  Created by Desmond Fitch on 2/7/22.
//

import SwiftUI

struct TabItem: Identifiable {
    var id = UUID()
    var icon: String
    var tab: Tab
    var name: String
}

var tabItems = [
    TabItem(icon: "house", tab: .home, name: "Home"),
    TabItem(icon: "magnifyingglass", tab: .explore, name: "Explore"),
    TabItem(icon: "plus.circle", tab: .add, name: "Add Song"),
    TabItem(icon: "person", tab: .account, name: "Account")
]

enum Tab: String {
    case home
    case explore
    case add
    case account
}
