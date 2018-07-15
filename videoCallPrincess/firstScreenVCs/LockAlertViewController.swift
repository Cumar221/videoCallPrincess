//
//  LockAlertViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 7/10/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

class LockAlertViewController: UIViewController {

  var princessName: String!
  @IBOutlet weak var descriptionLbl: UILabel!
  @IBOutlet weak var princessImg: circleImg!
  
  @IBOutlet weak var boxView: roundBoxView!
  
  override func viewDidLoad() {
    
        super.viewDidLoad()
    
    princessName = "\(princessName ?? "nil")"

    descriptionLbl.text = "Please puchase " + "\(princessName ?? "nil")" + " episdoes in the Parents Only section. Thank you!"
    
    if princessName == "Winter Princess" {
      princessImg.image = UIImage(named: "princessOne")
    } else if princessName == "Rapunzel" {
      princessImg.image = UIImage(named: "princessTwo")
    } else {
      princessImg.image = UIImage(named: "princessThree")
    }
    
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupView()
    
    let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
    //      let translate = CGAffineTransform(translationX: 125, y: 175)
    
    UIView.animate(withDuration: 0.2, animations: {
      self.boxView.transform = scale
    })
  }
  
  func setupView() {
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
  }
  
  @IBAction func exitBtn(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func okayBtn(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
