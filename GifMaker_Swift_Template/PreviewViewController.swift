//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Dolemite on 9/24/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

protocol PreviewVCDelegate {
   func previewVC(_ previewVC: UIViewController, didSave gif: Gif)
}

class PreviewViewController: UIViewController {
   
   @IBOutlet weak var gifImage: UIImageView!
   
   var gif: Gif?
   var delegate: PreviewVCDelegate? 
   
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
      print(url)
      let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
         self.dismiss(animated: true, completion: nil)
//      activityVC
//         .completionWithItemsHandler = { _, completed, _, _ in
//         if completed {
//            let _ = self.navigationController?.popToRootViewController(animated: true)
//         }
//      }
      present(activityVC, animated: true, completion: nil)
   }
   
   
   @IBAction func createAndSave(_ sender: UIButton) {
      delegate?.previewVC(self, didSave: gif!)
      let _ = navigationController?.popToRootViewController(animated: true)
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
