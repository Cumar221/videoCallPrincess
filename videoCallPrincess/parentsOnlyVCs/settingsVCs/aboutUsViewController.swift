//
//  aboutUsViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 5/29/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

class aboutUsViewController: UIViewController {
  
  override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
         navigationController?.popToRootViewController(animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  @IBAction func firstURLBtnPressed(_ sender: Any) {
    UIApplication.shared.open(URL(string: "https://www.facebook.com/VideoCallPrincess/")! as URL, options: [:], completionHandler: nil)
  }
  
  @IBAction func secondURLBtnPressed(_ sender: Any) {
    UIApplication.shared.open(URL(string: "https://www.facebook.com/VideoCallPrincess/")! as URL, options: [:], completionHandler: nil)
  }
  
}
