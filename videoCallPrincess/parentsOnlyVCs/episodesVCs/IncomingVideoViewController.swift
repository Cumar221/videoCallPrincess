//
//  IncomingVideoViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 7/5/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import NotificationCenter

class IncomingVideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
  
  @IBOutlet weak var videoView: UIView!
  var player: AVPlayer!
  var playerLayer: AVPlayerLayer!
  
  @IBOutlet weak var endCallUI: UIButton!
  @IBOutlet weak var startCallUI: UIButton!
  @IBOutlet weak var acceptLbl: UILabel!
  @IBOutlet weak var declineLbl: UILabel!
  
  @IBOutlet weak var princessNameLbl: UILabel!
  
  @IBOutlet weak var timeLbl: UILabel!
  
  
  @IBOutlet weak var elsaSquareImg: UIImageView!
  @IBOutlet weak var callingNameLbl: UILabel!
  @IBOutlet weak var callingLbl: UILabel!
  
  @IBOutlet weak var darkView: UIView!
  @IBOutlet weak var cameraView: UIView!
  let captureSession = AVCaptureSession()
  var frontCamera: AVCaptureDevice?
  var currentDevice: AVCaptureDevice?
  var audioDevice: AVCaptureDevice?
  var videoFileOutput:AVCaptureMovieFileOutput?
  var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
  
  var isRecording = false
  
  var videoName:String!
  
  var audioPlayer: AVAudioPlayer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupVideo()
    
    setupCaptureSession()
    setupDevice()
    setupInputOutput()
    setupPreviewLayer()
    startRunningCaptureSession()
    
    NotificationCenter.default.addObserver(self, selector: #selector(VideoViewController.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    
    cameraView.isHidden = false
    

    playSound(soundFile: "incomingRingTone", soundFileType: "mp3")
    

    }
  
  func setupVideo() {
    guard let url = Bundle.main.path(forResource: videoName, ofType: "mp4") else {
      debugPrint("Video not found")
      return
    }
    
    player = AVPlayer(url: URL(fileURLWithPath: url))
    playerLayer = AVPlayerLayer(player: player)
    
    videoView.layer.addSublayer(playerLayer)
    
    playerLayer.frame = videoView.bounds
  }
  
  func resetVideo() {
    let seconds : Int64 = 0
    let preferredTimeScale : Int32 = 1
    let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale)
    
    player.seek(to: seekTime)
    player.play()
    
  }
  
  func addTime() {
    let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    let mainQueue = DispatchQueue.main
    _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
      guard let currentItem = self?.player.currentItem else {return}
      self?.timeLbl.text = self?.getTimeString(from: currentItem.currentTime())
    })
  }
  
  func getTimeString(from time:CMTime) -> String {
    let totalSeconds = CMTimeGetSeconds(time)
    let minutes = Int(totalSeconds/60) % 60
    let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
    return String(format: "%02i:%02i", arguments: [minutes,seconds])
  }
  
  func setupCaptureSession() {
    captureSession.sessionPreset = AVCaptureSession.Preset.high
  }
  
  func setupDevice() {
    let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
      deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera, .builtInMicrophone],
      mediaType: nil,
      position: AVCaptureDevice.Position.unspecified)
    
    let devices = deviceDiscoverySession.devices
    
    for device in devices {
      if device.position == AVCaptureDevice.Position.front {
        frontCamera = device
      }
      if device.hasMediaType(AVMediaType.audio) {
        audioDevice = device
      }
    }
    currentDevice = frontCamera
  }
  
  func setupInputOutput() {
    do {
      let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
      let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)
      captureSession.addInput(captureDeviceInput)
      captureSession.addInput(audioDeviceInput)
      videoFileOutput = AVCaptureMovieFileOutput()
      captureSession.addOutput(videoFileOutput!)
    } catch {
      print(error)
    }
  }
  
  func setupPreviewLayer() {
    
    cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
    cameraPreviewLayer?.connection?.videoOrientation = .portrait
    
    cameraView.layer.addSublayer(cameraPreviewLayer!)
    
    cameraPreviewLayer?.position = CGPoint (x: self.cameraView.frame.width/2, y: self.cameraView.frame.height/2)
    cameraPreviewLayer?.bounds = cameraView.frame
  }
  
  func startRunningCaptureSession() {
    captureSession.startRunning()
  }
  
  @IBAction func startcall(_ sender: Any) {
    audioPlayer?.numberOfLoops = 0
//    audioPlayer?.stop()
    callingLbl.text = "Connecting..."
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.playSound(soundFile: "openCall", soundFileType: "mov")
      self.cameraView.layer.cornerRadius = 20
      self.cameraView.layer.masksToBounds = true
      let scale = CGAffineTransform(scaleX: 0.25, y: 0.25)
      let translate = CGAffineTransform(translationX: 125, y: 175)
      let translateEndBtn = CGAffineTransform(translationX: 100, y: 0)
      self.elsaSquareImg.isHidden = true
      self.callingNameLbl.isHidden = true
      self.callingLbl.isHidden = true
      self.darkView.isHidden = true
      self.startCallUI.isHidden = true
      self.declineLbl.isHidden = true
      self.acceptLbl.isHidden = true
      UIView.animate(withDuration: 0.3, animations: {
        self.cameraView.transform = scale.concatenating(translate)
        self.endCallUI.transform = translateEndBtn
      })
        self.recordVideo()
        self.resetVideo()
        self.addTime()
        
      }
    }

  
  @IBAction func endCall(_ sender: Any) {
    playSound(soundFile: "clickOff", soundFileType: "mp3")
    player.pause()
    recordVideo()
    captureSession.stopRunning()
    self.dismiss(animated: false, completion: nil)
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

  }
  
  func recordVideo() {
    let defaults = UserDefaults.standard
    let recordingPermission = defaults.bool(forKey: "RecordingKey")
    if recordingPermission == true {
      
      if !isRecording {
        isRecording = true
        
        let randomFilename = String.randomStringWithLength(16) + videoName + ".mov"
        var documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsDirectory.appendPathComponent(randomFilename)
        videoFileOutput?.startRecording(to: documentsDirectory, recordingDelegate: self)
      } else {
        isRecording = false
        
        videoFileOutput?.stopRecording()
      }
    } else {
      print("Recording Permission isOff")
    }
  }
  
  func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    if error != nil {
      print(error!)
      return
    }
  }
  
  func playSound(soundFile: String, soundFileType: String) {
    
    guard let url = Bundle.main.url(forResource: soundFile, withExtension: soundFileType) else { return }
    
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
      try AVAudioSession.sharedInstance().setActive(true)
      
      audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
      
      guard let audioPlayer = audioPlayer else { return }
      
      audioPlayer.play()
      audioPlayer.numberOfLoops = -1
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  @objc func playerDidFinishPlaying() {
    playSound(soundFile: "callEnded", soundFileType: "mov")
    player.pause()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.recordVideo()
      self.captureSession.stopRunning()
      self.dismiss(animated: false, completion: nil)
    }
  }
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
}
