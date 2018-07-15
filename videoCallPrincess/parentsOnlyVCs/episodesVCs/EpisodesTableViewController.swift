//
//  EpisodesTableViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 7/4/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var episode: UILabel!
    @IBOutlet weak var img: circleImg!
}

class EpisodesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SecondViewControllerDelegate {
    func settingsUpdated(light: Bool) {
        
    }
    
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
    var princessName: String!
    var princessNumber: String!
  
    let episodes = [0: ["Number": "One",
                    "Title": "princessOne"  ,
                    "Episode": "Episode I",
                    "Description": "Introduction"],
                1: ["Number": "Two",
                    "Title": "princessOne"  ,
                    "Episode": "Episode II",
                    "Description": "I Can't Wait to See You!"],
                2: ["Number":"Three",
                    "Title": "princessOne",
                    "Episode": "Episode III",
                    "Description":  "Happy Birthday!"],
                3: ["Number": "One",
                    "Title": "princessOne"  ,
                    "Episode": "Episode I",
                    "Description": "Introduction"],
                4: ["Number": "One",
                    "Title": "princessOne"  ,
                    "Episode": "Episode I",
                    "Description": "Introduction"],
                5: ["Number": "One",
                    "Title": "princessOne"  ,
                    "Episode": "Episode I",
                    "Description": "Introduction"],
                6: ["Number": "One",
                    "Title": "princessOne"  ,
                    "Episode": "Episode I",
                    "Description": "Introduction"],
                7: ["Number": "One",
                    "Title": "princessOne"  ,
                    "Episode": "Episode I",
                    "Description": "Introduction"],
                8: ["Number": "One",
                    "Title": "princessOne"  ,
                    "Episode": "Episode I",
                    "Description": "Introduction"]] as [Int : [String: String]]
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customCell
        
        if let title = episodes[indexPath.row]?["Title"]{
            cell.img.image = UIImage(named: "\(title)")
        }
        
        cell.episode.text = episodes[indexPath.row]?["Episode"]
        cell.info.text = episodes[indexPath.row]?["Description"]
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        princessNumber = episodes[indexPath.row]?["Title"]
        previewSegue((episodes[indexPath.row]?["Number"])!,princessName: "\(princessName ?? "nil")", princessNumber: "\(princessNumber ?? "nil")")
    }
  
    func previewSegue(_ episodeNumber: String, princessName: String, princessNumber: String) {
        let PreviewView = self.storyboard?.instantiateViewController(withIdentifier: "PreviewView") as! PreviewViewController
        PreviewView.episodeNumber = episodeNumber
        PreviewView.princessName = princessName
        PreviewView.princessNumber = princessNumber
        PreviewView.delegate = self
        PreviewView.providesPresentationContextTransitionStyle = true
        PreviewView.definesPresentationContext = true
        PreviewView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        PreviewView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        self.present(PreviewView, animated: true, completion: nil)
    }
}


