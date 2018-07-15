//
//  SettingsTableViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 2/18/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let recordingSwitchKeyConstant = "RecordingKey"
    let touchIDSwitchKeyConstant = "TouchIDKey"
  
    @IBOutlet weak var recordingSwitchUI: UISwitch!
    @IBOutlet weak var touchIDSwitchUI: UISwitch!
    
    weak var delegate: SegueHandler?
  
  override func viewDidLoad() {
        super.viewDidLoad()
      
    let defaults = UserDefaults.standard
      
    if (defaults.bool(forKey: recordingSwitchKeyConstant)) {
        recordingSwitchUI.isOn = true
      } else {
        recordingSwitchUI.isOn = false
    }
    
    if (defaults.bool(forKey: touchIDSwitchKeyConstant)) {
        touchIDSwitchUI.isOn = true
    } else {
        touchIDSwitchUI.isOn = false
    }
    
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            delegate?.segueToNext(identifier: "AboutUsView")
        }
        if indexPath.row == 3 {
            delegate?.segueToNext(identifier: "WhyourAppisSafeView")
        }
        if indexPath.row == 4 {
            UIApplication.shared.open(URL(string: "https://www.facebook.com/VideoCallPrincess/")! as URL, options: [:], completionHandler: nil)
        }
        //...
    }

  @IBAction func recordingSwitch(_ sender: UISwitch) {
    if (sender.isOn == true)
    {
      let defaults = UserDefaults.standard
      defaults.set(true, forKey: recordingSwitchKeyConstant)
    } else {
      let defaults = UserDefaults.standard
      defaults.set(false, forKey: recordingSwitchKeyConstant)
    }
  }
  
  @IBAction func touchIDSwitch(_ sender: UISwitch) {
    if (sender.isOn == true)
    {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: touchIDSwitchKeyConstant)
    } else {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: touchIDSwitchKeyConstant)
    }
  }
  
}
