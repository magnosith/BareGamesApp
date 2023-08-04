//
//  GameDetailViewController.swift
//  bare-games
//
//  Created by Student on 17/07/23.
//

import UIKit

class GameDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var gameItem: Game?
    var gameDetail: GameDetail?
    var currentCellIndex: Int = 0
    var gamesServiceDetail = GameDetailService()
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var platformType: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var publisherGame: UILabel!
    @IBOutlet weak var developerGame: UILabel!
    @IBOutlet weak var collectionViewDetail: UICollectionView!
    @IBOutlet weak var spinnerProgress: UIActivityIndicatorView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    var timer: Timer?
    var isDownloading = false
    var checkButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = gameItem?.title.capitalized
        shareButton.tintColor = UIColor.systemPink
        downloadButton.tintColor = UIColor.systemPink
        
        spinnerProgress.hidesWhenStopped = true
        progressView.isHidden = true
        fetchGameDetails()
        spinnerProgress.stopAnimating()
        collectionViewDetail.delegate = self
        collectionViewDetail.dataSource = self
    
    }

    
    @IBAction func shareButtonTapped(_ sender: UIButton) {

        guard let gameTitle = gameItem?.title else {
                return
            }
            
            let activityController = UIActivityViewController(activityItems: [gameTitle], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = sender
            present(activityController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func dowloadButtonTapped(_ sender: UIButton) {
       
        downloadButton.tintColor = UIColor.systemPink
        if isDownloading {
                   stopDownload()
               } else {
                   startDownload()
               }
    }
    
    
    func startDownload() {
            isDownloading = true
        let image = UIImage(systemName: "stop.fill")
            downloadButton.setImage(image, for: .normal)
            downloadButton.setTitle("Stop Download", for: .normal)
            
            progressView.isHidden = false
        
            
            let totalTime: TimeInterval = 5.0
            UIView.animate(withDuration: totalTime) {
                self.progressView.setProgress(1.0, animated: true)
            }
        
            checkButton = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + totalTime) {
                self.stopDownload()
            }
        }
        
        func stopDownload() {
            isDownloading = false
            downloadButton.setTitle(" Open", for: .normal)
            progressView.isHidden = true
            if checkButton {
                downloadButton.tintColor = UIColor.blue
            } else {
                downloadButton.tintColor = UIColor.systemPink
            }
            
            let image = UIImage(systemName: "play.fill")
            downloadButton.setImage(image, for: .normal)
            progressView.setProgress(0, animated: false)
            
        }
    
    
    func updateUI(){
        gameTitle.text = gameDetail?.title
        shortDescription.text = gameDetail?.short_description
        publisherGame.text = gameDetail?.publisher
        developerGame.text = gameDetail?.developer
        platformType.text = gameDetail?.platform
        categoryName.text = gameDetail?.genre
        releaseDate.text = gameDetail?.release_date
        pageControl.numberOfPages = gameDetail?.screenshots.count ?? 3
    }
    
      
    func fetchGameDetails(){
       
        Task.init {
            
            do{
                spinnerProgress.startAnimating()
                self.gameDetail = try await self.gamesServiceDetail.getDetailGames(id: gameItem!.id)
                    self.updateUI()
                    self.collectionViewDetail.reloadData()
                spinnerProgress.stopAnimating()
                  
                
            } catch {
                print("Erro ao buscar dados: \(error)")
            }
        }
}
}

extension GameDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
 
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return gameDetail?.screenshots.count ?? 3
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollection", for: indexPath) as! ScreenShotsCollectionViewCell
    
    Task.init {
        await fetchLoadImage(indexPath: indexPath, cell: cell)
    }
       
    return cell
}
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
             pageControl.currentPage = indexPath.row
              
        
    }
    
    func fetchLoadImage(indexPath: IndexPath, cell: ScreenShotsCollectionViewCell) async {
        if let screenshotURLString = gameDetail?.screenshots[indexPath.row]?.image, let screenShotURL = URL(string: screenshotURLString) {
       
            do{
                let (data, response) = try await URLSession.shared.data(from: screenShotURL)
                let image = UIImage(data: data)

                await MainActor.run {
                    
                    if let currentPath = collectionViewDetail.indexPath(for: cell), currentPath == indexPath {
                        
                        cell.imageScreens.image = image
                        pageControl.currentPage = indexPath.row
                }
                    
                   
                }
            }catch {
                print("Failed to fetch image: \(error)")
            }
        }
    }
    
    
}



