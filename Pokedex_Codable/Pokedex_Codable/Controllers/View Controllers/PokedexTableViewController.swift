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
    var pokedex: Pokedex?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkingController.fetchPokedex(with: String("https://pokeapi.co/api/v2/pokemon/")) { [weak self] result in
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
    
    // MARK: - functions
    func reloadTableViewOnMainThread() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let pokedex = pokedex else { return }
        
        if indexPath.row == pokedexResults.count - 1 {
            NetworkingController.fetchPokedex(with: pokedex.next) { [weak self] result in
                switch result {
                case .success(let topLevel):
                    self?.pokedex = topLevel
                    self?.pokedexResults.append(contentsOf: topLevel.results)
                    self?.reloadTableViewOnMainThread()
                    
                case.failure(let error):
                    print(error.errorDescription ?? "Dont fuckin know")
                }
            }
        }
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
