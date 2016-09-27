//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Dolemite on 9/25/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation

//
//  Gif.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/4/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

struct Gif {
   
   var url: URL?
   var caption: String?
   var gifImage: UIImage?
   var videoURL: URL?
   var gifData: NSData?

   init(gifURL: URL, videoURL: URL, caption: String?) {
      self.url = gifURL
      self.videoURL = videoURL
      self.caption = caption
      self.gifImage = UIImage.gif(url: url!.absoluteString)
      self.gifData = nil
   }
   
   init(name: String) {
      gifImage = UIImage.gif(name: name)
   }
   
//
//-(instancetype)initWithCoder:(NSCoder *)decoder{
//
//    self = [super init];
//
//    // Unarchive the data, one property at a time
//    self.url = [decoder decodeObjectForKey:@"gifURL"];
//    self.caption = [decoder decodeObjectForKey:@"caption"];
//    self.videoURL = [decoder decodeObjectForKey:@"videoURL"];
//    self.gifImage = [decoder decodeObjectForKey:@"gifImage"];
//    self.gifData = [decoder decodeObjectForKey:@"gifData"];
//
//    return self;
//}
//
//-(void)encodeWithCoder:(NSCoder *)coder {
//    [coder encodeObject:self.url forKey: @"gifURL"];
//    [coder encodeObject:self.caption forKey: @"caption"];
//    [coder encodeObject:self.videoURL forKey: @"videoURL"];
//    [coder encodeObject:self.gifImage forKey: @"gifImage"];
//    [coder encodeObject: self.gifData forKey:@"gifData"];
//}
//
//@end
}
