//
//  GameDetailService.swift
//  bare-games
//
//  Created by Student on 18/07/23.
//

import Foundation

struct GameDetailService {
    
    let gameEndpoint = "https://www.freetogame.com/api/game"
    
    func getDetailGames(id: Int) async throws -> GameDetail? {
        var components = URLComponents(string: gameEndpoint)
        components?.queryItems = [URLQueryItem(name: "id", value: "\(id)")]
        
        if let url = components?.url {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let result = try JSONDecoder().decode(GameDetail.self, from: data)
                return result
            }
        }
        return nil
    }
    
    
    enum ArcadeControllerError: Error, LocalizedError {
        case gamesNotFound
        case imageDataMissing
    }
    
}
