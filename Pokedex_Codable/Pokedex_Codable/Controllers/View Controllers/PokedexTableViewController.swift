//
//  PokedexTableViewController.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import UIKit

class PokedexTableViewController: UITableViewController {
    
    // MARK: - Properties
    var pokedexResults: [PokemonResults] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkingController.fetchPokedex(with: URL(string: "https://pokeapi.co/api/v2/pokemon")!) { [weak self] result in
            switch result {
            case .success(let pokedex):
                self?.pokedexResults = pokedex.results
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("There was an error!", error.errorDescription!)
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokedexResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell", for: indexPath) as? PokemonTableViewCell else {return UITableViewCell()}
        let pokemonURLString = pokedexResults[indexPath.row].url
        cell.updateViews(pokemonURlString: pokemonURLString)
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toPokemonDetail",
              let pokemonDetailVC = segue.destination as? PokemonViewController,
              let indexPath = tableView.indexPathForSelectedRow?.row else { return }
        let pokemonToSend = pokedexResults[indexPath]
        NetworkingController.fetchPokemon(with: pokemonToSend.url) { result in
            switch result {
            case .success(let pokemon):
                DispatchQueue.main.async {
                    pokemonDetailVC.pokemon = pokemon
                }
            case .failure(let error):
                print(error.errorDescription ?? "An Unknown Error Has Occured")
            }
        }
    }
}
