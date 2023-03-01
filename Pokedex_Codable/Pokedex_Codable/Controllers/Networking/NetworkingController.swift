//
//  NetworkingController.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation
import UIKit.UIImage

struct NetworkingController {
    
    private static let baseURLString = "https://pokeapi.co"
    private static let kPokemonComponent = "pokemon"
    private static let kApiComponent = "api"
    private static let kV2Compmonent = "v2"
    
    // TODO - Update to a URL as a parameter to allow for pagination
    static func fetchPokedex(with url: String, completion: @escaping(Result<Pokedex, ResultError>) -> Void) {
        
        guard let finalURL = URL(string: url) else { completion(.failure(.invalidURL)) ; return }
        
        URLSession.shared.dataTask(with: finalURL) { dTaskData, _, error in
            if let error = error {
                print("Encountered error: \(error.localizedDescription)")
                completion(.failure(.thrownError(error)))
            }
            
            guard let pokemonData = dTaskData else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let pokedex =  try JSONDecoder().decode(Pokedex.self, from: pokemonData)
                completion(.success(pokedex))
            } catch {
                print("Encountered error when decoding the data:", error.localizedDescription)
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchPokemon(with urlString: String, completion: @escaping (Result<Pokemon, ResultError>) -> Void) {
        
        guard let pokemonURL = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: pokemonURL) { dTaskData, _, error in
            if let error = error {
                print("Encountered error: \(error.localizedDescription)")
                completion(.failure(.thrownError(error))) ; return
            }
            
            guard let pokemonData = dTaskData else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let pokemon =  try JSONDecoder().decode(Pokemon.self, from: pokemonData)
                completion(.success(pokemon))
            } catch {
                print("Encountered error when decoding the data:", error.localizedDescription)
                completion(.failure(.unableToDecode)) ; return
            }
        }.resume()
    }
    
    static func fetchImage(for pokemonImagePath: String, completion: @escaping (Result<UIImage, ResultError>) -> Void) {
        guard let imageURL = URL(string: pokemonImagePath) else {return}
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("Encountered error: \(error.localizedDescription)")
                completion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            guard let pokemonImage = UIImage(data: data) else {
                completion(.failure(.unableToDecode))
                return
            }
            completion(.success(pokemonImage))
        }.resume()
    }
}// end
