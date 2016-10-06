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
import AVFoundation

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
      self.present(picker, animated: true, completion: nil)
      
   }
   
   func convertVideoToGif(videoURL: URL) {
      let regift = Regift(sourceFileURL: videoURL as URL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
      if let gifURL = regift.createGif() {
         let gif = Gif(gifURL: gifURL, videoURL: videoURL, caption: nil)
         display(gif: gif)
      } else {
         display(gif: nil)
      }
   }
   
   func display(gif: Gif?) {
      let editorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
      editorVC.gif = gif
      DispatchQueue.main.async {
         self.navigationController?.pushViewController(editorVC, animated: true)
      }
   }
   //   -(void)cropVideoToSquare:(NSURL*)rawVideoURL start:(NSNumber*)start duration:(NSNumber*)duration {
   //   //Create the AVAsset and AVAssetTrack
   //   AVAsset *videoAsset = [AVAsset assetWithURL:rawVideoURL];
   //   AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
   
   //   // Crop to square
   //   AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
   //   videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.height);
   //   videoComposition.frameDuration = CMTimeMake(1, 30);
   //
   //   AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
   //   instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30) );
   func cropVideoToSquare(videoURL: URL) {
      // Create the AVAsset and AVAssetTrack
      let videoAsset = AVAsset(url: videoURL)
      let videoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0]
      
      // Crop to square
      let videoHeight = videoTrack.naturalSize.height
      let videoWidth = videoTrack.naturalSize.width
      let videoComposition = AVMutableVideoComposition()
      videoComposition.renderSize = CGSize(width: videoHeight, height: videoHeight)
      videoComposition.frameDuration = CMTimeMake(1, 30)
      
      let instruction = AVMutableVideoCompositionInstruction()
      instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
      
      // rotate to portrait
      let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
      let centerTransform = CGAffineTransform(translationX: videoHeight, y: -(videoWidth - videoHeight) / 2)
      let centerAndRotate = centerTransform.rotated(by: CGFloat(M_PI_2))
      transformer.setTransform(centerAndRotate, at: kCMTimeZero)
      instruction.layerInstructions = [transformer]
      videoComposition.instructions = [instruction]
      
      // export
      let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
      exporter?.videoComposition = videoComposition
      let path = createPath()
      exporter?.outputURL = URL(fileURLWithPath: path)
      exporter?.outputFileType = AVFileTypeQuickTimeMovie
      exporter?.exportAsynchronously() {
         let croppedURL = exporter?.outputURL
         self.convertVideoToGif(videoURL: croppedURL!)
      }
   }
   
   func createPath() -> String {
      
      let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
      let documentsDirectory = paths[0]
      let fileManager = FileManager.default
      var outputURL = documentsDirectory.appending("/output")
      do {
         try fileManager.createDirectory(atPath: outputURL, withIntermediateDirectories: true, attributes: nil)
      } catch {
         print(error)
      }
      outputURL = outputURL.appending("/output.mov")
      // Remove Existing File
      do {
         try fileManager.removeItem(atPath: outputURL)
      } catch {
         // first time running, don't worry 
      }
      
      return outputURL
   }
}

extension UIViewController: UIImagePickerControllerDelegate {
   
   public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      
      let mediaType = info[UIImagePickerControllerMediaType] as! CFString
      if mediaType == kUTTypeMovie {
         let rawVideoURL = info[UIImagePickerControllerMediaURL] as! NSURL
//         UISaveVideoAtPathToSavedPhotosAlbum(rawVideoURL.path!, nil, nil, nil)
         dismiss(animated: true, completion: nil)
//         convertVideoToGif(videoURL: rawVideoURL as URL)
         cropVideoToSquare(videoURL: rawVideoURL as URL)
      }
   }
   
   public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion: nil)
   }
   
}
