//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Dolemite on 9/24/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
   
   var gif: Gif?
   @IBOutlet weak var gifImage: UIImageView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      let url = gif!.url!
      gifImage.image = UIImage.gif(url: url.absoluteString)
      // Do any additional setup after loading the view.
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   @IBAction func share(_ sender: UIButton) {
      let url = gif!.url!
      let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
      activityVC.completionWithItemsHandler = { _, completed, _, _ in
         if completed {
            let _ = self.navigationController?.popToRootViewController(animated: true)
         }
      }
      present(activityVC, animated: true, completion: nil)
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
