//
//  RoundImg.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 5/21/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit
import AVKit
import Foundation

class circleBtn: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
  
      layer.cornerRadius = frame.size.width/2
      clipsToBounds = true
    }
}


class circleView: UIView {
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = frame.size.width/2
    clipsToBounds = true
    
  }
}

class circleImg: UIImageView {
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = frame.size.width/2
    clipsToBounds = true
    
  }
}

class shadowView: UIView {
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.width / 2
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    layer.shadowRadius = 1.0
    layer.shadowOpacity = 0.5
    layer.masksToBounds = false
  }
}

class roundBtn: UIButton {
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height/2
  }
}

class roundBoxView: UIView {
  override func layoutSubviews() {
    
    layer.cornerRadius = 10
    
  }
}

class VideoView: UIView {
  
  override static var layerClass: AnyClass {
    return AVPlayerLayer.self;
  }
  
  var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer;
  }
  
  var player: AVPlayer? {
    
    get {
      return playerLayer.player
    }
    set {
      playerLayer.player = newValue;
    }
  }
}




