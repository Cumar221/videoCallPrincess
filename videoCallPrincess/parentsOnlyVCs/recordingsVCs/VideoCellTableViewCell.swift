//
//  VideoCellTableViewCell.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 2/1/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCellTableViewCell: UITableViewCell {
    
  weak var delegate: VideoTableViewCellDelegate?

  @IBOutlet weak var videoView: VideoView!
  

  @IBOutlet weak var silentVideoView: VideoView!


  @IBOutlet weak var playBtnUI: UIButton!
  @IBOutlet weak var stopBtnUI: UIButton!
  @IBOutlet weak var shareBtnUI: UIButton!
  @IBOutlet weak var fullScreenBtn: UIButton!
  @IBOutlet weak var progressView: UIProgressView!
  @IBOutlet weak var leftClock: UILabel!
  @IBOutlet weak var rightClock: UILabel!
    
  var url: URL!
  var videoURL: URL!
  var deleteURL: URL!
  var silentVideo: String!
  var timer = Timer()
  var progressTimer = Timer()
  
    var upSeconds = 0
    var upTimer = Timer()
    var upTimerIsOn = false
    
  var silentPlayerTimer = Timer()

  var durationTime: Float64!
  var durationSeconds: Int!
  var durationMinutes: Int!

  override func awakeFromNib() {
    super.awakeFromNib()

    playBtnUI.layer.cornerRadius = playBtnUI.frame.size.width/2
    stopBtnUI.layer.cornerRadius = stopBtnUI.frame.size.width/2
    
  }
    
  func setupVideo() {
    let asset = AVAsset(url: url)
    
//    let player = AVPlayer(url: url)
//
//    videoView?.playerLayer.player = player
  
    
    let duration = asset.duration
    durationTime = CMTimeGetSeconds(duration)
    durationMinutes = Int((durationTime.truncatingRemainder(dividingBy: 3600)) / 60)
    durationSeconds = Int(durationTime.truncatingRemainder(dividingBy: 60))
    rightClock.text = String(format: "%02i:%02i", arguments: [durationMinutes,durationSeconds])
  }
    
    func setupSilentVideo() {
        
        extractSilentVideo()
        
        guard let url = Bundle.main.path(forResource: silentVideo, ofType: "mp4") else {
            debugPrint("Video not found")
            return
        }
      
      let silentPlayer = AVPlayer(url: URL(fileURLWithPath: url))
      
      silentVideoView?.playerLayer.player = silentPlayer
      
    }
    
    func extractSilentVideo() {
        let path:String = url.path
        let index = path.index(path.endIndex, offsetBy: -25)
        let mySubstring = path[index...] // playground
        let myString = String(mySubstring)
        
        let newIndex = myString.index(myString.startIndex, offsetBy: 21)
        let myNewSubstring = myString[..<newIndex] // Hello
        silentVideo = String(myNewSubstring)
        print(silentVideo)
    }
    
  func playVideo() {
    let seconds : Int64 = 0
    let preferredTimeScale : Int32 = 1
    let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale)
    
    videoView.player?.seek(to: seekTime)
    videoView.player?.play()
    
    silentVideoView.player?.seek(to: seekTime)
    silentVideoView.player?.isMuted = true
    silentVideoView.player?.play()
    
    
  }
    

  @IBAction func startBtn(_ sender: Any) {
    playVideo()
    
    timer = Timer.scheduledTimer(timeInterval: durationTime, target: self, selector: #selector(VideoCellTableViewCell.silentVideoPause), userInfo: nil, repeats: true)
    
    playBtnUI.isHidden = true
    stopBtnUI.isHidden = false
    fullScreenBtn.isHidden = false
    progressView.isHidden = false
    leftClock.isHidden = false
    rightClock.isHidden = false
    
    progressTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(VideoCellTableViewCell.go), userInfo: nil, repeats: true)
    RunLoop.main.add(progressTimer, forMode: RunLoopMode.commonModes)
    
    if upTimerIsOn == false {
        upTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.main.add(upTimer, forMode: RunLoopMode.commonModes)
    }
  }

  @IBAction func stopBtn(_ sender: Any) {
    videoView.player?.pause()
    silentVideoView.player?.pause()
    timer.invalidate()
    playBtnUI.isHidden = false
    stopBtnUI.isHidden = true
    fullScreenBtn.isHidden = true
    progressView.isHidden = true
    leftClock.isHidden = true
    rightClock.isHidden = true
    progressTimer.invalidate()
    progressView.progress = 0.00
    
    upTimer.invalidate()
    upSeconds = 0
    leftClock.text = "\(timeFormatted(upSeconds))"
    upTimerIsOn = false

  }
    
    @objc func silentVideoPause() {
        silentVideoView.player?.pause()
        timer.invalidate()
        playBtnUI.isHidden = false
        stopBtnUI.isHidden = true
        
        progressTimer.invalidate()
        progressView.progress = 0.00
        
        upTimer.invalidate()
        upSeconds = 0
        leftClock.text = "\(timeFormatted(upSeconds))"
        upTimerIsOn = false
        
    }
    
    @objc func go() {
        progressView.progress = Float(Double(progressView.progress) + 0.01/durationTime)
    }
    
    @IBAction func shareVideoPressed(_ sender: UIButton) {
      delegate?.shareVideo(senderCell: self, shareVideoURL: url, silentVideoName: silentVideo)
    }
  
  
    var buttonAction: ((Any) -> Void)?
  
    @IBAction func deleteVideoPressed(_ sender: UIButton) {
        delegate?.deleteVideo(senderCell: self, deleteVideoURL: url)
      
    }
    
    @objc func updateTime() {
        upSeconds = upSeconds + 1
        leftClock.text = "\(timeFormatted(upSeconds))"

    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func fullScreenPressed(_ sender: Any) {

        
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }
    

}
