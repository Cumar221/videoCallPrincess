//
//  LaunchScreenViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 5/18/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var timer = Timer()
    
    let recordingSwitchKeyConstant = "RecordingKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(LaunchScreenViewController.go), userInfo: nil, repeats: true)
        
        perform(#selector(LaunchScreenViewController.showMainController), with: nil, afterDelay: 3.0)
    
      
    }
    
    
    @objc func showMainController() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "LaunchedBefore")
        
        if launchedBefore == false  {
            
            let Tutorial = self.storyboard?.instantiateViewController(withIdentifier: "Tutorial") as! TutorialPageViewController
            self.present(Tutorial, animated: true, completion: nil)
            
            UserDefaults.standard.set(true, forKey: "LaunchedBefore")
        }
        else {
            performSegue(withIdentifier: "showMainScreen", sender: self)
        }
    
    }
    
    @objc func go() {
        progressView.progress += 0.01/3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
