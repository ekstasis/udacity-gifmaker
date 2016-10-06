//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Dolemite on 9/24/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController, UITextFieldDelegate {

   @IBOutlet weak var caption: UITextField!
   @IBOutlet weak var gifImageView: UIImageView!
   var gif: Gif? = nil
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      caption.delegate = self
    }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      let gifFromRecording = gif?.gifImage
      gifImageView.image = gifFromRecording
      subscribeToKeyboardNotifications()
      title = "Add a Caption"
//      applyTheme
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   func textFieldDidBeginEditing(_ textField: UITextField) {
      textField.placeholder = ""
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
   }
   
   func subscribeToKeyboardNotifications() {
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object:nil)
   }
   
   func unsubscribeFromKeyboardNotifications() {
      NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
      NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
   }
   
   func keyboardWillShow(notification: Notification) {
      if view.frame.origin.y >= 0 {
         var rect = view.frame
         rect.origin.y -= getKeyboardHeight(notification: notification)
         view.frame = rect
      }
   }
   
   func keyboardWillHide(notification: Notification) {
      if self.view.frame.origin.y < 0 {
         var rect = view.frame
         rect.origin.y += getKeyboardHeight(notification: notification)
         view.frame = rect;
      }
   }
   
   func dismissKeyboard() {
      caption.resignFirstResponder()
   }
   
   func getKeyboardHeight(notification: Notification) -> CGFloat {
      let userInfo = notification.userInfo
      let keyboardFrameEnd = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
      let keyboardFrameEndRect = keyboardFrameEnd.cgRectValue
      return keyboardFrameEndRect.size.height
   }
   
   @IBAction func presentPreview(_ sender: UIBarButtonItem) {
      let previewVC = storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
      gif?.caption = caption.text
      let regift = Regift(sourceFileURL: gif!.videoURL!, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
      let gifURL = regift.createGif(caption.text, font: caption.font)
      let newGif = Gif(gifURL: gifURL!, videoURL: gif!.videoURL!, caption: caption.text)
      previewVC.gif = newGif
      dismissKeyboard()
      navigationController?.pushViewController(previewVC, animated: true)
   }
   
//   - (IBAction)presentPreview:(id)sender {
//   GifPreviewViewController *previewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GifPreviewViewController"];
//   self.gif.caption = self.captionTextField.text;
//   
//   Regift *regift = [[Regift alloc] initWithSourceFileURL:self.gif.videoURL destinationFileURL:nil frameCount:kFrameCount delayTime:kDelayTime loopCount:kLoopCount];
//   
//   UIFont *captionFont = self.captionTextField.font;
//   NSURL *gifURL = [regift createGifWithCaption:self.captionTextField.text font:captionFont];
   
//   Gif *newGif = [[Gif alloc] initWithGifURL:gifURL videoURL:self.gif.videoURL caption:self.captionTextField.text];
//   previewVC.gif = newGif;
//   
//   [self.navigationController pushViewController:previewVC animated:YES];
//   }

}
