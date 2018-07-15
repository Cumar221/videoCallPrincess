//
//  Extensions.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 1/30/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


extension String {
  static func randomStringWithLength(_ length: Int) -> String {
    let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789"
    let randomString = NSMutableString(capacity: length)
    for _ in 0 ..< length {
      let length = UInt32 (letters.length)
      let rand = arc4random_uniform(length)
      randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    return randomString as String
  }
}

@objc class Helper: NSObject {
  class func orientationFromTransform(transform: CGAffineTransform) -> (orientation: UIImageOrientation, isPortrait: Bool) {
    var assetOrientation = UIImageOrientation.up
    var isPortrait = false
    if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
      assetOrientation = .right
      isPortrait = true
    } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
      assetOrientation = .left
      isPortrait = true
    } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
      assetOrientation = .up
    } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
      assetOrientation = .down
    }
    return (assetOrientation, isPortrait)
  }
  
  @objc class func videoCompositionInstructionForTrack(track: AVCompositionTrack, asset: AVAsset, isPortraitMode: Bool, isSmaller: Bool = false) -> AVMutableVideoCompositionLayerInstruction {
    let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
    let assetTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
    
    let transform = assetTrack.preferredTransform
    let assetInfo = orientationFromTransform(transform: transform)

    if isPortraitMode {
      var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
      if assetInfo.isPortrait {
        scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
        scaleToFitRatio = isPortraitMode && isSmaller ? scaleToFitRatio / 4 : scaleToFitRatio
        let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
        if isPortraitMode && isSmaller {
          let assetSize = CGSize(width: scaleToFitRatio * assetTrack.naturalSize.height, height: scaleToFitRatio * assetTrack.naturalSize.width)
          let translation = CGAffineTransform(translationX: UIScreen.main.bounds.width - assetSize.width - 30,
                                              y: UIScreen.main.bounds.height - assetSize.height - 30)
          instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(translation),
                                   at: kCMTimeZero)
        } else {
          instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor),
                                   at: kCMTimeZero)
        }
      } else {
        scaleToFitRatio = isPortraitMode && isSmaller ? scaleToFitRatio / 4 : scaleToFitRatio
        let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
        var concat = assetTrack.preferredTransform.concatenating(scaleFactor)
        if assetInfo.orientation == .down {
          let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat.pi)
          let windowBounds = UIScreen.main.bounds
          let yFix = assetTrack.naturalSize.height + windowBounds.height
          let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
          concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
        }
        instruction.setTransform(concat, at: kCMTimeZero)
      }
    } else {
      var scaleToFitRatio = 175 / assetTrack.naturalSize.width
      if assetInfo.isPortrait {
        scaleToFitRatio = 175 / assetTrack.naturalSize.height
        let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
        let translation = CGAffineTransform(translationX: isSmaller ? 175 : 0,
                                            y: 0)
        instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(translation),
                                 at: kCMTimeZero)
      } else {
        let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
        let translation = CGAffineTransform(translationX: isSmaller ? 175 : 0,
                                            y: 0)
        var concat = assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(translation)
        if assetInfo.orientation == .down {
          let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat.pi)
          let windowBounds = UIScreen.main.bounds
          let yFix = assetTrack.naturalSize.height + windowBounds.height
          let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
          concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor).concatenating(translation)
        }
        instruction.setTransform(concat, at: kCMTimeZero)
      }
    }
    return instruction
  }
}

