//
//  TrackView.swift
//  FastTrack
//
//  Created by Mateusz Brychczynski on 29/05/2023.
//

import SwiftUI

struct TrackView: View {
    @State private var isHovering = false
    let track: Track
    let onSelected: (Track) -> Void
    
    
    var body: some View {
        Button {
            onSelected(track)
        } label: {
            ZStack(alignment: .bottom) {
                AsyncImage(url: track.artworkURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                    case .failure(_):
                        Image(systemName: "questionmark")
                            .symbolVariant(.circle)
                            .font(.largeTitle)
                    default:
                        ProgressView()
                    }
                }
                .frame(width: 150, height: 150)
                .scaleEffect(isHovering ? 1.2 : 1.0)
                
                VStack {
                    Text(track.trackName)
                        .lineLimit(2)
                        .font(.headline)
                    
                    Text(track.artistName)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                }
                .padding(5)
                .frame(width: 150)
                .background(.regularMaterial)
            }
        }
        .buttonStyle(.borderless)
        .border(.primary, width:  isHovering ? 3 : 0)
        .onHover { hovering in
            withAnimation {
                isHovering = hovering
            }
        }
    }
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView(track: Track(trackId: 1, artistName: "Nirvana", trackName: "Smells Like Teen Spirit", previewUrl: URL(string: "abc")!, artworkUrl100: "https://bit.ly/teen-spirit")) { track in
            
        }
    }
}
