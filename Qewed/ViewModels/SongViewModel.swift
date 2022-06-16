//
//  SongVuViewModel.swift
//  Qewed
//
//  Created by Desmond Fitch on 3/29/22.
//

import Foundation

class SongViewModel: ObservableObject {
    
    private let service = SongService()
    @Published var song: Song
    
    init(song: Song) {
        self.song = song
        checkIfUserLikedSong()
    }
    
    func likeSong() {
        service.likeSong(song) {
            self.song.didLike = true
        }
    }
    
    func unlikeSong() {
        service.unlikeSong(song) {
            self.song.didLike = false
        }
    }
    
    func checkIfUserLikedSong() {
        service.checkIfUserLikedSong(song) { didLike in
            if didLike {
                self.song.didLike = true
            }
        }
    }
}
