//
//  PokemonViewController.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import UIKit

class PokemonViewController: UIViewController {

    @IBOutlet weak var pokemonIDLabel: UILabel!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var pokemonSpriteImageView: UIImageView!
    @IBOutlet weak var pokemonMovesTableView: UITableView!
    
    // MARK: - Properties
    var pokemon: Pokemon? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonMovesTableView.delegate = self
        pokemonMovesTableView.dataSource = self
    }
    
    func updateViews() {
        guard let pokemon = pokemon else { return }
        NetworkingController.fetchImage(for: pokemon.sprites.frontShiny) { result in
            switch result {
            case .success(let sprite):
                DispatchQueue.main.async {
                    self.pokemonSpriteImageView.image = sprite
                    self.pokemonMovesTableView.reloadData()
                }
            case .failure(let error):
                print(error.errorDescription ?? "An Unknown Error Has Occured")
            }
        }
    }
}// End

extension PokemonViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Moves"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon?.moves.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moveCell", for: indexPath)
        
        guard let pokemonIndex = pokemon?.moves[indexPath.row] else { return UITableViewCell() }
        var config = cell.defaultContentConfiguration()
        config.text = pokemonIndex.move.name
        cell.contentConfiguration = config
        
        return cell
    }
}
