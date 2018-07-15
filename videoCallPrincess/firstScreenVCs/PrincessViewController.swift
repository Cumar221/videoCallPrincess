//
//  ViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 1/4/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

class PrincessViewController: UIViewController {

    @IBOutlet weak var callYourPrincessLbl: UILabel!
  
  @IBOutlet weak var lockOne: UIImageView!
  @IBOutlet weak var darkViewOne: circleView!
  @IBOutlet weak var princessOneLockedBtn: circleBtn!
  
  @IBOutlet weak var lockTwo: UIImageView!
  @IBOutlet weak var darkViewTwo: UIView!
  @IBOutlet weak var princessTwoLockedBtn: circleBtn!
  
    
  @IBOutlet weak var lockThree: UIImageView!
  @IBOutlet weak var darkViewThree: UIView!
  @IBOutlet weak var princessThreeLockedBtn: circleBtn!
  
    

  var princessVideoName:String!

  var audioPlayer: AVAudioPlayer?

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "segueVideo" {
      let controller = segue.destination as! VideoViewController
      controller.videoName = princessVideoName
    }

  }
  
  let defaults = UserDefaults.standard

  override func viewDidLoad() {
    super.viewDidLoad()


    permissionAlert()

    view.layoutIfNeeded()


    NotificationCenter.default.addObserver(self, selector: #selector(dismissAllPasscodeScreenAndPresentParentScreen), name: NSNotification.Name.init("dismissAllPasscodeScreenAndPresentParentScreen"), object: nil)
    
    callYourPrincessLbl.adjustsFontSizeToFitWidth = true
    
    
    if (defaults.string(forKey: "princessOneEpisodeSelected")) == "" {
      print("Princess One Lock Enabled")
    } else {
      princessOneLockedBtn.isHidden = true
      lockOne.isHidden = true
      darkViewOne.isHidden = true
    }
    
    if (defaults.string(forKey: "princessTwoEpisodeSelected")) == "" {
      print("Princess Two Lock Enabled")
    } else {
      princessTwoLockedBtn.isHidden = true
      lockTwo.isHidden = true
      darkViewTwo.isHidden = true
    }
    
    if (defaults.string(forKey: "princessThreeEpisodeSelected")) == "" {
      print("Princess Three Lock Enabled")
    } else {
      princessThreeLockedBtn.isHidden = true
      lockThree.isHidden = true
      darkViewThree.isHidden = true
    }
    
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let permissionLaunchedBefore = UserDefaults.standard.bool(forKey: "PermissionLaunchedBefore")

    if permissionLaunchedBefore == false  {

      permissionAlert()
      print("working")

      UserDefaults.standard.set(true, forKey: "PermissionLaunchedBefore")
    } else {

    }

  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func permissionAlert () {
    let permissionAlert = self.storyboard?.instantiateViewController(withIdentifier: "permissionAlert") as! PermissionViewController
    permissionAlert.providesPresentationContextTransitionStyle = true
    permissionAlert.definesPresentationContext = true
    permissionAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    permissionAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    self.present(permissionAlert, animated: true, completion: nil)
  }

  @objc func dismissAllPasscodeScreenAndPresentParentScreen() {
    self.dismiss(animated: true) { [weak self] in
      guard let `self` = self else { return }
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParentsViewController")
      self.present(vc!, animated: true, completion: nil)
    }
  }


  @IBAction func princessOneBtnPressed(_ sender: AnyObject) {
    playSound(soundFile: "clickOn")
    princessVideoName = defaults.string(forKey: "princessOneEpisodeSelected")
    performSegue(withIdentifier: "segueVideo", sender: self)

  }

  @IBAction func princessTwoBtnPressed(_ sender: Any) {
    playSound(soundFile: "clickOn")
    princessVideoName = defaults.string(forKey: "princessTwoEpisodeSelected")
    performSegue(withIdentifier: "segueVideo", sender: self)
  }

  @IBAction func princessThreeBtnPressed(_ sender: Any) {
    playSound(soundFile: "clickOn")
    princessVideoName = defaults.string(forKey: "princessThreeEpisodeSelected")
    performSegue(withIdentifier: "segueVideo", sender: self)
  }
  
  
  @IBAction func princessOneLockedBtnPressed(_ sender: Any) {
    presentLockAlert(name: "Winter Princess")
  }
  
  
  @IBAction func princessTwoLockedBtnPressed(_ sender: Any) {
    presentLockAlert(name: "Rapunzel")
  }
  
  @IBAction func princessThreeLockedBtnPressed(_ sender: Any) {
    presentLockAlert(name: "Island Princess")
  }
  
  func presentLockAlert(name: String) {
  let lockAlert = self.storyboard?.instantiateViewController(withIdentifier: "LockAlert") as! LockAlertViewController
  lockAlert.princessName = name
  lockAlert.providesPresentationContextTransitionStyle = true
  lockAlert.definesPresentationContext = true
  lockAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
  lockAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
  self.present(lockAlert, animated: true, completion: nil)
  }

  func playSound(soundFile: String) {

    guard let url = Bundle.main.url(forResource: soundFile, withExtension: "mp3") else { return }

    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
      try AVAudioSession.sharedInstance().setActive(true)

      audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

      guard let audioPlayer = audioPlayer else { return }

      audioPlayer.play()

    } catch let error {
      print(error.localizedDescription)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }


}

