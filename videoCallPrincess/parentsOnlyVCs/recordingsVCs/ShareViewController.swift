//
//  ShareViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 2/16/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
  @IBOutlet weak var verticalBtnView: UIButton!
  @IBOutlet weak var verticalFillView: UIView!
  @IBOutlet weak var verticalImgView: UIView!
  @IBOutlet weak var boxBtnView: UIButton!
  @IBOutlet weak var boxFillView: UIView!
  @IBOutlet weak var boxImgView: UIView!
  @IBOutlet weak var shareBoxView: UIView!
  
    var delegate: ShareViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
      
      verticalBtnView.layer.cornerRadius = verticalBtnView.frame.size.width/2
      verticalBtnView.layer.borderWidth = 1
      verticalBtnView.backgroundColor = UIColor.white
      
      verticalFillView.layer.cornerRadius = verticalFillView.frame.size.width/2
      
      boxBtnView.layer.cornerRadius = boxBtnView.frame.size.width/2
      boxBtnView.layer.borderWidth = 1
      boxBtnView.backgroundColor = UIColor.white
      
      boxFillView.layer.cornerRadius = boxFillView.frame.size.width/2
      
      verticalImgView.layer.borderColor = UIColor(red:170/255.0, green:170/255.0, blue:170/255.0, alpha: 1.0).cgColor
      verticalImgView.layer.borderWidth = 1
      
      boxImgView.layer.borderColor = UIColor(red:170/255.0, green:170/255.0, blue:170/255.0, alpha: 1.0).cgColor
      boxImgView.layer.borderWidth = 1
    
      
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
      
      let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
      //      let translate = CGAffineTransform(translationX: 125, y: 175)
      
      UIView.animate(withDuration: 0.2, animations: {
        self.shareBoxView.transform = scale
      })
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
  
  
  
  @IBAction func cancelBtn(_ sender: Any) {
    delegate?.cancelBtnAction()
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func verticalBtnAction(_ sender: Any) {
    
    if verticalFillView.isHidden == true {
      verticalFillView.isHidden = false
      boxFillView.isHidden = true
    }
    delegate?.verticalBtnAction()
  }
  
  @IBAction func boxBtnAction(_ sender: Any) {
    
    if boxFillView.isHidden == true {
      boxFillView.isHidden = false
      verticalFillView.isHidden = true
    }
    delegate?.boxBtnAction()
  }
  
  @IBAction func shareBtnAction(_ sender: Any) {
        delegate?.shareBtnAction()
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
