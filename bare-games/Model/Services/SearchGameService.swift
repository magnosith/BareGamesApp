//
//  SearchGameService.swift
//  bare-games
//
//  Created by Student on 01/08/23.
//

import Foundation

struct SearchGameService {
    
    
    
    func searchGames(category: String) async throws -> [Game] {
        
        let gameEndpoint = "https://www.freetogame.com/api/games?category=\(category)"
        
        if let url = URL(string: gameEndpoint) {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let result = try JSONDecoder().decode(Array<Game>.self, from: data)
                print("Got Data!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                return result
                
            }
        }
        return []
    }
    
    
    enum ArcadeControllerError: Error, LocalizedError {
        case gamesNotFound
        case imageDataMissing
    }
    
}
