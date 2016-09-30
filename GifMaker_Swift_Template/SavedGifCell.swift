//
//  SavedGifCell.swift
//  GifMaker_Swift_Template
//
//  Created by Dolemite on 9/30/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifCell: UICollectionViewCell {
   
   @IBOutlet weak var gifImageView: UIImageView!
   
   func configureFor(gif: Gif) {
       gifImageView.image = gif.gifImage;
   }
   
}
