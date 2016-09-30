//
//  SavedGifsController.swift
//  GifMaker_Swift_Template
//
//  Created by Dolemite on 9/30/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class SavedGifsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PreviewVCDelegate {
   
   @IBOutlet weak var noGifsView: UIStackView!
   @IBOutlet weak var collectionView: UICollectionView!
   
   var savedGifs = [Gif]()
   let cellMargin: CGFloat = 12.0
   
   var gifDirectory: String {
      let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
      return directory! + "/savedGifs"
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      savedGifs = NSKeyedUnarchiver.unarchiveObject(withFile: gifDirectory) as? [Gif] ?? [Gif]()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      let empty = savedGifs.isEmpty 
      noGifsView.isHidden = !empty
      collectionView.reloadData()
   }
   
   // MARK: Collection View Delegate
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let detailVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailVC
      detailVC.gif = savedGifs[indexPath.row]
      present(detailVC, animated: true)
   }
   // MARK: Collection View Data Source
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return savedGifs.count 
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gif Cell", for: indexPath) as! SavedGifCell
      cell.configureFor(gif: savedGifs[indexPath.row])
      
      return cell
   }
   
   // MARK: Collection View Flow Layout Delegate
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let width = (collectionView.frame.width - (cellMargin * 2)) / 2
      return CGSize(width: width, height: width)
   }
   
   func previewVC(_ previewVC: UIViewController, didSave gif: Gif) {
      gif.gifData = NSData(contentsOfFile: gif.url!.absoluteString)
      savedGifs.append(gif)
      print(NSKeyedArchiver.archiveRootObject(savedGifs, toFile: gifDirectory))
   }
}
