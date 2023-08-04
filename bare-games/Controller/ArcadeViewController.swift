//
//  ArcadeViewController.swift
//  bare-games
//
//  Created by Student on 17/07/23.
//

import UIKit

class ArcadeViewController: UIViewController {
    
    let gamesService = GameService()
    
    var data: [Game] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinnerProgress: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        spinnerProgress.hidesWhenStopped = true
        spinnerProgress.startAnimating()
        Task.init {
            do{
            
                data = try await self.gamesService.getGames()
                print(data)
                self.tableView.reloadData()
                spinnerProgress.stopAnimating()
            } catch {
                print(error)
            }
        }
        
    }
    

}

extension ArcadeViewController: UITableViewDelegate {
    
}

extension ArcadeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func fetchLoadImage(indexPath: IndexPath, cell: GamesCustomCell) async {
        
        let data = data[indexPath.row].thumbnail
        let dataURL = URLComponents(string: "\(data)")
        
        do{
            guard let imageURL = dataURL else {
                throw GameService.ArcadeControllerError.imageDataMissing
            }
            
            let (data, response) = try await URLSession.shared.data(from: imageURL.url!)
            let image = UIImage(data: data)
            
            await MainActor.run {
                
                if let currentPath = tableView.indexPath(for: cell), currentPath == indexPath {
                    cell.imageGame.image = image
                }
            }
        }catch {
            print("Failed to fetch image: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GamesCustomCell
        
        cell.titleGame.text = data[indexPath.row].title
        cell.publisherTitle.text = data[indexPath.row].publisher
        cell.imageGame.image = nil
        
        Task.init {
            await fetchLoadImage(indexPath: indexPath, cell: cell)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let gameItem = data[indexPath.row]
        
        let arcadeViewController = self.storyboard?.instantiateViewController(withIdentifier: "ArcadeGameDetail") as! GameDetailViewController
        
        arcadeViewController.gameItem = gameItem
        print(gameItem)
        navigationController?.pushViewController(arcadeViewController, animated: true)
        
    }
    
}
