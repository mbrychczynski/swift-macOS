//
//  ContentView.swift
//  FastTrack
//
//  Created by Mateusz Brychczynski on 29/05/2023.
//

import AVKit
import SwiftUI

struct ContentView: View {
    enum SearchState {
        case none, searching, success, error
    }
    
    let gridItems: [GridItem] = [
        GridItem(.adaptive(minimum: 150, maximum: 200))
    ]
    @AppStorage("searchText") var searchText = ""
    @State private var tracks = [Track]()
    @State private var audioPlayer: AVPlayer?
    @State private var searchState = SearchState.none
    @State private var previousSearches: Set<String> = Set(UserDefaults.standard.stringArray(forKey: "previousSearches") ?? [])
    
    var windowTitle: String {
        switch searchState {
        case .none:
            return "Music Search"
        case .searching:
            return "Searching..."
        case .success:
            return "Music Search (\(tracks.count) Results)"
        case .error:
            return "Music Search (Error)"
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                Text("Previous Searches")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                ForEach(previousSearches.sorted(), id: \.self) { searchText in
                    Button(action: {
                        self.searchText = searchText
                        startSearch()
                    }) {
                        Text(searchText)
                    }
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Music Search")
        } detail: {
            VStack {
//                HStack {
//                    TextField("Search for a song", text: $searchText)
//                        .onSubmit(startSearch)
//                    Button("Search", action: startSearch)
//                }
//                .padding([.top, .horizontal])
                switch searchState {
                case .none:
                    Text("Enter a search term to begin.")
                        .frame(maxHeight: .infinity)
                case .searching:
                    ProgressView()
                        .frame(maxHeight: .infinity)
                case .success:
                    ScrollView {
                        LazyVGrid(columns: gridItems) {
                            ForEach(tracks) { track in
                                TrackView(track: track, onSelected: play)
                            }
                        }
                        .padding()
                    }
                case .error:
                    Text("Sorry, your search failed - please check your internet connection then try again.")
                        .frame(maxHeight: .infinity)
                }
            }
            
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search, startSearch)
        .navigationTitle(windowTitle)
        .frame(minWidth: 400, minHeight: 300)
        .onAppear {
            NSApp.mainWindow?.minSize = NSSize(width: 400, height: 300)
        }
    }
    
    func performSearch() async throws {
        guard let searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchText)&limit=100&entity=song") else { return }
        let (data, _) = try await URLSession.shared.data(from: url)
        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
        tracks = searchResult.results
    }
    
    func startSearch() {
        searchState = .searching
        
        previousSearches.insert(searchText)
        UserDefaults.standard.set(Array(previousSearches), forKey: "previousSearches")
        
        Task {
            do {
                try await performSearch()
                searchState = .success
            } catch {
                searchState = .error
            }
        }
    }
    
    func play(_ track: Track) {
        audioPlayer?.pause()
        audioPlayer = AVPlayer(url: track.previewUrl)
        audioPlayer?.play()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
