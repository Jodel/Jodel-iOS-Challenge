//
//  FeedCell.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

final class FeedCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var image: UIImage? {
        imageView.image
    }
    
    var title: String? {
        titleLabel.text
    }
    
    func configure(for image: UIImage, with title: String) {
        imageView.image = image
        self.titleLabel.text = title
    }
    
    
    
}
