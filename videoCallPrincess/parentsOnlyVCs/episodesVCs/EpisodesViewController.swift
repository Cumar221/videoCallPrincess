//
//  EpisodesViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 6/25/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

class EpisodesViewController: UIViewController {
    
    
    
    @IBOutlet weak var episodesContainerView: UIView!
    
    @IBOutlet weak var episodesTitle: UILabel!
    
    var titleName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodesTitle.text = "\(titleName ?? "nil") Episodes"
        
        guard let childViewController = storyboard?.instantiateViewController(withIdentifier: "EpisodesView") as? EpisodesTableViewController else {
            print("Creating ViewController from ChildVCID failed")
            return
        }
        
        childViewController.princessName = titleName
        addChildViewController(childViewController)
        //episodesContainerView.addSubview(childViewController.view)
        didMove(toParentViewController: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
