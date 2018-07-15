// PrincessEpisodesTableViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 6/17/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

class PrincessEpisodesTableViewController: UITableViewController {
    
    
    var princessName: String!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEpisodes" {
            let controller = segue.destination as! EpisodesViewController
            controller.titleName = princessName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            princessName = "Winter Princess"
            performSegue(withIdentifier: "segueEpisodes", sender: self)
        }
        else if indexPath.row == 1 {
            princessName = "Repunzel"
            comingSoonAlert(name: princessName)
            //    performSegue(withIdentifier: "segueEpisodes", sender: self)
            
        }
        else if indexPath.row == 2 {
            princessName = "Island Princess"
            comingSoonAlert(name: princessName)
            //    performSegue(withIdentifier: "segueEpisodes", sender: self)
        }
        //...
    }
    
    func comingSoonAlert(name: String) {
        let alert = UIAlertController(title: "Coming Soon!", message: "\(name) can't wait to meet you. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil ))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
