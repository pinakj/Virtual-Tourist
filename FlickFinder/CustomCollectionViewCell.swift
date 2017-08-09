//
//  CustomCollectionViewCell.swift
//  FlickFinder
//
//  Created by Pinak Jalan on 7/31/17.
//  Copyright © 2017 Pinak Jalan. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var activityIndicator:UIActivityIndicatorView!
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        if imageView.image == nil {
            DispatchQueue.main.async {
                print("animating")
                self.activityIndicator.startAnimating()

            }
        }
    }
    
}
