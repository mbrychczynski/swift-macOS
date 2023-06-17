//
//  ContentView.swift
//  StormViewer
//
//  Created by Mateusz Brychczynski on 20/05/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: Int?
    
    var body: some View {
        NavigationSplitView {
            List(0..<10, selection: $selectedImage) { number in
                Text("Storm \(number + 1)")
            }
            .frame(width: 150)
        } detail: {
            if let selectedImage = selectedImage {
                Image(String(selectedImage))
                    .resizable()
                    .scaledToFit()
            } else {
                Text("Please selecet an image")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(minWidth: 480, minHeight: 320)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
