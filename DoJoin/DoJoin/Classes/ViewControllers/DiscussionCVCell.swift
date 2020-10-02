//
//  DiscussionCVCell.swift
//  DoJoin
//
//  Created by Ijaz on 02/10/2020.
//

import UIKit
import SDWebImage

class DiscussionCVCell: UICollectionViewCell {
    
    @IBOutlet weak var discussionTitle: UILabel!
    @IBOutlet weak var discussionImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code§
        
        discussionImg.layer.cornerRadius = 5.0
        discussionImg.layer.masksToBounds = true
        
    }
    
    func configureCell(DTitle: String, discussionImgURL: String) {
        self.discussionTitle.text = DTitle
        
        let newURL = "http://208.109.13.111:7171" + discussionImgURL + ".gif"
        let url = URL(string: newURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        if (url != nil){
            discussionImg.sd_setImage(with: url, completed: nil) // SD Image library is used as managed images very well and also cache the images for fast loading.
        }
    }
}
