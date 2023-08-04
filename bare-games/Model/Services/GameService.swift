//
//  GameService.swift
//  bare-games
//
//  Created by Student on 17/07/23.
//

import Foundation

struct GameService {
    
    let gameEndpoint = "https://www.freetogame.com/api/games"
    
    func getGames () async throws -> [Game] {
        if let url = URL(string: gameEndpoint){
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200{
                let result = try JSONDecoder().decode(Array<Game>.self, from: data)
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
