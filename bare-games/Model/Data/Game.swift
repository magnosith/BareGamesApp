//
//  Game.swift
//  bare-games
//
//  Created by Student on 17/07/23.
//

import Foundation

struct Game: Codable, Hashable {
    var id: Int
    var title: String
    var thumbnail: String
    var short_description: String
    var genre: String
    var platform: String
    var publisher: String
    var developer: String
    var release_date: String
}

struct GameDetail: Codable {
    var id: Int
    var title: String
    var thumbnail: String
    var status: String
    var short_description: String
    var game_url: String
    var genre: String
    var platform: String
    var publisher: String
    var developer: String
    var release_date: String
    var screenshots: Array<GameImage?>
}

