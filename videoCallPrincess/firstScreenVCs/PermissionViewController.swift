//
//  PermissionViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 2/18/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit
import Photos

class PermissionViewController: UIViewController {
  
    @IBOutlet weak var permissionBox: UIView!
  
    @IBOutlet weak var cameraBtn: UIView!
    @IBOutlet weak var cameraBtnImg: UIImageView!
  
  
    @IBOutlet weak var microphoneBtn: UIView!
    @IBOutlet weak var microphoneBtnImg: UIImageView!
  
    @IBOutlet weak var photoBtn: UIView!
    @IBOutlet weak var photoBtnImg: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
            
      

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        
        let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
        //      let translate = CGAffineTransform(translationX: 125, y: 175)
        
        UIView.animate(withDuration: 0.2, animations: {
          self.permissionBox.transform = scale
        })
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
  
    @IBAction func cameraPermission(_ sender: Any) {
      AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
        if granted {
          //access granted
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "RecordingKey")
        } else {
          //access denied
          print("Camera Permission Denied")
        }
      })
      
      cameraBtnImg.image = UIImage(named: "checkmarkPink")
      cameraBtn.backgroundColor = UIColor.white
      cameraBtn.layer.borderColor = UIColor(red:254/255.0, green:138/255.0, blue:185/255.0, alpha: 1.0).cgColor
      cameraBtn.layer.borderWidth = 3.0
      
    }
  
    @IBAction func microphoneAccess(_ sender: Any) {
      AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
        if granted {
          //access granted
        } else {
          //access denied
          print("Microphone Permission Denied")
        }
      })
      
      microphoneBtnImg.image = UIImage(named: "checkmarkPink")
      microphoneBtn.backgroundColor = UIColor.white
      microphoneBtn.layer.borderColor = UIColor(red:254/255.0, green:138/255.0, blue:185/255.0, alpha: 1.0).cgColor
      microphoneBtn.layer.borderWidth = 3.0
      
    }
  
    @IBAction func libraryAccess(_ sender: Any) {
      
      let photos = PHPhotoLibrary.authorizationStatus()
      if photos == .notDetermined {
        PHPhotoLibrary.requestAuthorization({status in
          if status == .authorized{
            //access granted
          } else {
            //access denied
            print("Photo Permission Denied")
          }
        })
      }
      
      photoBtnImg.image = UIImage(named: "checkmarkPink")
      photoBtn.backgroundColor = UIColor.white
      photoBtn.layer.borderColor = UIColor(red:254/255.0, green:138/255.0, blue:185/255.0, alpha: 1.0).cgColor
      photoBtn.layer.borderWidth = 3.0
    }
  
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "TouchIDKey")
    }

}
