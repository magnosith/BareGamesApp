//
//  GamesCustomCell.swift
//  bare-games
//
//  Created by Student on 17/07/23.
//

import UIKit

class GamesCustomCell: UITableViewCell {

    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var titleGame: UILabel!
    
    @IBOutlet weak var publisherTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        let iconImage = UIImage(systemName: "livephoto.play")?.withTintColor(UIColor.systemPink)
        imageGame.image = iconImage
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
