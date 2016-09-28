//
//  UIViewController_Record_Extension.swift
//  GifMaker_Swift_Template
//
//  Created by Dolemite on 9/24/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0 // 0 means loop forever

extension UIViewController: UINavigationControllerDelegate {
   
   @IBAction public func presentOptions(sender: UIButton) {
      if !UIImagePickerController.isSourceTypeAvailable(.camera) {
         self.getVideo(source: UIImagePickerControllerSourceType.photoLibrary)
      }  else {
         let alertController = UIAlertController(title: "Choose Video", message: "Choose a method", preferredStyle: .actionSheet)
         let cameraAction = UIAlertAction(title: "Video Camera", style: .default, handler: { _ in
            self.getVideo(source: UIImagePickerControllerSourceType.camera)
         })
         let libraryAction = UIAlertAction(title: "Video Library", style: .default, handler: { _ in
            self.getVideo(source: UIImagePickerControllerSourceType.photoLibrary)
         })
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         alertController.addAction(cameraAction)
         alertController.addAction(libraryAction)
         alertController.addAction(cancelAction)
         present(alertController, animated: true, completion: nil)
         alertController.view.tintColor = UIColor(colorLiteralRed: 1.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
      }
   }
   
   func getVideo(source: UIImagePickerControllerSourceType) {
      
      // create image picker
      let picker = UIImagePickerController()
      
      // set picker options: sourcetype, mediatype,   allowsEditing, delegate
      picker.sourceType = source
      picker.mediaTypes = [kUTTypeMovie as String]
      picker.allowsEditing = false
      picker.delegate = self
      
      // present controller
      present(picker, animated: true, completion: nil)
      
   }
   
   func convertVideoToGif(videoURL: URL) {
      let regift = Regift(sourceFileURL: videoURL as URL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
      let gifURL = regift.createGif()
      let gif = Gif(gifURL: gifURL!, videoURL: videoURL, caption: nil)
      display(gif: gif)
   }
   
   func display(gif: Gif) {
      let editorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
      editorVC.gif = gif
      navigationController?.pushViewController(editorVC, animated: true)
   }
}

extension UIViewController: UIImagePickerControllerDelegate {
   
   public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
      let mediaType = info[UIImagePickerControllerMediaType] as! CFString
      if mediaType == kUTTypeMovie {
         let rawVideoURL = info[UIImagePickerControllerMediaURL] as! NSURL
         UISaveVideoAtPathToSavedPhotosAlbum(rawVideoURL.path!, nil, nil, nil)
         dismiss(animated: true, completion: nil)
         convertVideoToGif(videoURL: rawVideoURL as URL)
      }
   }
   
   public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion: nil)
   }
   
}
