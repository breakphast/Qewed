//
//  SongFilterViewModel.swift
//  Qewed
//
//  Created by Desmond Fitch on 3/30/22.
//

import Foundation

enum SongFilterViewModel: Int, CaseIterable {
    case likes, allSongs
    
    var title: String {
        switch self {
        case .allSongs: return "Songs"
        case .likes: return "Likes"
        }
    }
}
