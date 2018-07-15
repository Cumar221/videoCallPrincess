//
//  ParentsViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 1/14/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

protocol SegueHandler: class {
    func segueToNext(identifier: String)
}


class ParentsViewController: UIViewController, SegueHandler {
    
  
    @IBOutlet weak var recordingsView: UIView!
    
    @IBOutlet weak var purchaseView: UIView!
    
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.layer.cornerRadius = 20.0
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        segmentedControl.layer.borderWidth = 2.0
        segmentedControl.layer.masksToBounds = true
        
        let font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)

    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            recordingsView.isHidden = false
            purchaseView.isHidden = true
            settingsView.isHidden = true
        case 1:
            recordingsView.isHidden = true
            purchaseView.isHidden = false
            settingsView.isHidden = true
        case 2:
            recordingsView.isHidden = true
            purchaseView.isHidden = true
            settingsView.isHidden = false
        default:
            break;
        }
    }
    
  @IBAction func backBtn(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    //this will take you back to passcodeVC must fix!
  }
  
    func segueToNext(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsView" {
            let dvc = segue.destination as! SettingsTableViewController
            dvc.delegate = self
        }

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        super.viewWillAppear(animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//        super.viewWillDisappear(animated)
//    }
    

}
