//
//  Pokemon.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation

struct Pokedex: Decodable {
    let next: String
    let results: [PokemonResults]
}

struct PokemonResults: Decodable {
    let name: String
    let url: String
}

struct Pokemon: Decodable {
    let sprites: Sprites
    let name: String
    let id: Int
    let moves: [Moves]
}

struct Sprites: Decodable {
    private enum CodingKeys: String, CodingKey {
        case frontShiny = "front_shiny"
    }
    
    let frontShiny: String
}

struct Moves: Decodable {
    let move: Move
}

struct Move: Decodable {
    let name: String
    let url: String
}
