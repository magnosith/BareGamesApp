

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {

    let searchController = UISearchController()
    var gameData: [Game] = []
    let searchService = SearchGameService()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinnerProgress: UIActivityIndicatorView!
    @IBOutlet weak var messageToWrite: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        spinnerProgress.hidesWhenStopped = true
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = ("Search Category Type")
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor : UIColor.systemPink], for: .normal)
       
        messageToWrite.isHidden = false
       
        }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        gameData = []
        collectionView.reloadData()
        messageToWrite.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            gameData = []
            collectionView.reloadData()
        }
    }
    
     
    func searchCategoryType(category: String){

        Task.init {
            do{
                messageToWrite.isHidden = true
                spinnerProgress.startAnimating()
                gameData = try await self.searchService.searchGames(category: category);                print(gameData)
                await MainActor.run{
                 collectionView.reloadData()
                    spinnerProgress.stopAnimating()
                }
                
            } catch {
                print(error)
            }
        }
        
        
    }

    }
    


extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCellSearch", for: indexPath) as! HeaderCell
        cell.titleGame.text = gameData[indexPath.row].title
        cell.short_description.text = gameData[indexPath.row].publisher
        
        Task.init {
            await fetchGameImage(indexPath: indexPath, cell: cell)
        }
        
     
        return cell
    }
    
    
    func fetchGameImage(indexPath: IndexPath, cell: HeaderCell) async {
        
        let data = gameData[indexPath.row].thumbnail
        let dataURL = URLComponents(string: "\(data)")
        
        if let imageURL = dataURL?.url{
            
            do {
                let (data, response) = try await URLSession.shared.data(from: imageURL)
                let image = UIImage(data: data)
                
                await MainActor.run{
                   
                    if let currentPath = collectionView.indexPath(for: cell), currentPath == indexPath {
                        cell.imageView.image = image
                        cell.imageView.layer.cornerRadius = 12
                }
                }
            } catch {
                print("Failed to fetch imageL \(error)")
            }
        }
    }

    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text{
            gameData = []
            collectionView.reloadData()
            searchCategoryType(category: text)
        }
    }
    
}


