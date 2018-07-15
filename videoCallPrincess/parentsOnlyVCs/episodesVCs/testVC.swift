//
//  testVC.swift
//  videoCallPrincess
//
//  Created by Omar Yusuf on 2018-07-14.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

class myCell: UITableViewCell {
   
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var img: UIImageView!
}

class testVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let list = [0: ["Title": "princessOne"  ,
                    "Episode": "Episode I",
                    "Description": "Introduction"],
                1: ["Title": "princessTwo"  ,
                    "Episode": "Episode II",
                    "Description": "I Can't Wait to See You!"],
                2: ["Title": "princessThree",
                    "Episode": "Episode III",
                    "Description":  "Happy Birthday!"]] as [Int : [String: String]]
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myCell
        
        if let title = list[indexPath.row]?["Title"]{
            cell.img.image = UIImage(named: "\(title)")
            print(title)
        }
        
        cell.lbl2.text = list[indexPath.row]?["Episode"]
        cell.lbl1.text = list[indexPath.row]?["Description"]
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
