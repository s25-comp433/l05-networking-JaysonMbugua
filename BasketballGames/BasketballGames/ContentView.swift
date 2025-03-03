//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Game: Codable {
    var id: Int
    var team: String
    var opponent: String
    var date: String
    var isHomeGame: Bool
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var games = [Game]()
    var body: some View {
        List(games, id: \.id) { game in
            VStack(alignment: .leading, spacing: nil) {
                HStack(alignment: .center, spacing: nil) {
                    Text("\(game.team) vs. \(game.opponent)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(game.score.unc) - \(game.score.opponent)")
                        .font(.headline)
                }
                
                HStack(alignment: .center, spacing: nil) {
                    Text(game.date)
                        .font(.caption)
                    
                    Spacer()
                    
                    Text(game.isHomeGame ? "Home" : "Away")
                        .font(.caption)
                }
            }
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let URL = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: URL)
            
            if let decodedResponse = try? JSONDecoder().decode([Game].self, from: data) {
                games = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
