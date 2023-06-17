//
//  Track.swift
//  FastTrack
//
//  Created by Mateusz Brychczynski on 29/05/2023.
//

import Foundation

struct SearchResult: Decodable {
    let results: [Track]
    
}

struct Track: Identifiable, Decodable {
    var id: Int { trackId }
    let trackId: Int
    let artistName: String
    let trackName: String
    let previewUrl: URL
    let artworkUrl100: String
    var artworkURL: URL? {
        let replacedString = artworkUrl100.replacingOccurrences(of: "100x100", with: "300x300")
        return URL(string: replacedString)
    }
}
