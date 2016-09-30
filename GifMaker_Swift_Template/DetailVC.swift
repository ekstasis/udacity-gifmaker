//
//  DetailVC.swift
//  GifMaker_Swift_Template
//
//  Created by Dolemite on 9/30/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

   @IBOutlet weak var imageView: UIImageView!
   
   var gif: Gif?
   
    override func viewDidLoad() {
        super.viewDidLoad()

      imageView.image = gif?.gifImage
    }
    
   @IBAction func close(_ sender: UIButton) {
      dismiss(animated: true)
   }

   @IBAction func share(_ sender: AnyObject) {
      let activityVC = UIActivityViewController(activityItems: [gif!.gifData!], applicationActivities: nil)
      activityVC.completionWithItemsHandler = { (_,_,_,_) in
         print("activity CH")
      }
      present(activityVC, animated: true)
   }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
