//
//  HeaderCell.swift
//  bare-games
//
//  Created by Student on 01/08/23.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleGame: UILabel!
    @IBOutlet weak var short_description: UILabel!
    @IBOutlet weak var FrameView: UIView!
    
        override func prepareForReuse() {
            let livePhotoImage = UIImage(systemName: "livephoto.play")?.withTintColor(UIColor.systemPink)
            imageView.image = livePhotoImage
        }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        FrameView.clipsToBounds = true
        FrameView.layer.cornerRadius = 10
    }
    
    
}
