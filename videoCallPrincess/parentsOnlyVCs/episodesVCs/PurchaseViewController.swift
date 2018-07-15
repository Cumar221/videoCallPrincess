//
//  PurchaseViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 1/19/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
  
    @IBOutlet weak var premiumImg: UIImageView!
    @IBOutlet weak var premiumLblOne: UILabel!
    @IBOutlet weak var premiumLblTwo: UILabel!
    @IBOutlet weak var premiumLblThree: UILabel!
  
  @IBOutlet weak var premiumView: UIView!
  @IBOutlet weak var deluxeView: UIView!
  @IBOutlet weak var VIPView: UIView!
  
  @IBOutlet weak var premiumPriceLbl: UILabel!
  @IBOutlet weak var deluxePriceLbl: UILabel!
  @IBOutlet weak var VIPPriceLbl: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      
        premiumImg.isUserInteractionEnabled = true
        premiumLblOne.isUserInteractionEnabled = true
        premiumLblTwo.isUserInteractionEnabled = true
        premiumLblThree.isUserInteractionEnabled = true
      
      let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
      tap.minimumPressDuration = 0
      premiumView.addGestureRecognizer(tap)
      
      let tapdulx = UILongPressGestureRecognizer(target: self, action: #selector(tapHandlerDulx))
      tapdulx.minimumPressDuration = 0
      deluxeView.addGestureRecognizer(tapdulx)
      
      let tapVIP = UILongPressGestureRecognizer(target: self, action: #selector(tapHandlerVIP))
      tapVIP.minimumPressDuration = 0
      VIPView.addGestureRecognizer(tapVIP)
      
      let defaults = UserDefaults.standard
      if (defaults.bool(forKey: "Premium")) == true {
        premiumPriceLbl.text = "Purchased"
      } else {
      }
      
      if (defaults.bool(forKey: "Deluxe")) == true {
        deluxePriceLbl.text = "Purchased"
      } else {
      }
      
      if (defaults.bool(forKey: "VIP")) == true {
        VIPPriceLbl.text = "Purchased"
      } else {
      }
      
      //
      if(SKPaymentQueue.canMakePayments()) {
        print("IAP is enabled, loading")
        let productID: NSSet = NSSet(objects: "com.videoCallPrincess.princessOneEpisodeOne", "com.videoCallPrincess.princessOneEpisodeTwo", "com.videoCallPrincess.princessOneEpisodeThree", "com.videoCallPrincess.princessTwoEpisodeOne", "com.videoCallPrincess.princessTwoEpisodeTwo", "com.videoCallPrincess.princessTwoEpisodeThee", "com.videoCallPrincess.princessThreeEpisodeOne", "com.videoCallPrincess.princessThreeEpisodeTwo", "com.videoCallPrincess.princessThreeEpisodeThree", "com.videoCallPrincess.princessOneAllEpisodes", "com.videoCallPrincess.princessTwoAllEpisodes", "com.videoCallPrincess.princessThreeAllEpisodes", "com.videoCallPrincess.Premium", "com.videoCallPrincess.Deluxe", "com.videoCallPrincess.VIP")
        let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
        request.delegate = self
        request.start()
      } else {
        print("please enable IAPS")
      }
      
    }
    
    @IBAction func callEpisodesCategory(_ sender: Any) {
        let callEpisodeCategorySegue = self.storyboard?.instantiateViewController(withIdentifier: "CallEpisodeCategory") as! UINavigationController
        callEpisodeCategorySegue.providesPresentationContextTransitionStyle = true
        callEpisodeCategorySegue.definesPresentationContext = true
        callEpisodeCategorySegue.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        callEpisodeCategorySegue.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(callEpisodeCategorySegue, animated: true, completion: nil)
    }
  
  @IBAction func restoreBtnPressed(_ sender: Any) {
    SKPaymentQueue.default().add(self)
    SKPaymentQueue.default().restoreCompletedTransactions()
  }

  @objc func tapHandler(gesture: UITapGestureRecognizer) {
    if gesture.state == .began {
      premiumView.alpha = CGFloat(0.5)
    } else if  gesture.state == .ended {
      premiumView.alpha = CGFloat(1.0)
      
      if premiumPriceLbl.text == "Purchased" {
        print("Premium Paid!")
      } else {
        previewSegue("Premium")
      }
    }
  }
  
  @objc func tapHandlerDulx(gesture: UITapGestureRecognizer) {
    if gesture.state == .began {
      deluxeView.alpha = CGFloat(0.5)
    } else if  gesture.state == .ended {
      deluxeView.alpha = CGFloat(1.0)
      
      if deluxePriceLbl.text == "Purchased" {
        print("Deluxe Paid!")
      } else {
        previewSegue("Deluxe")
      }
    }
  }
  
  @objc func tapHandlerVIP(gesture: UITapGestureRecognizer) {
    if gesture.state == .began {
      VIPView.alpha = CGFloat(0.5)
    } else if  gesture.state == .ended {
      VIPView.alpha = CGFloat(1.0)
      
      if VIPPriceLbl.text == "Purchased" {
        print("VIP Paid!")
      } else {
        previewSegue("VIP")
      }
    }
  }
  
  func previewSegue(_ name: String) {
    let premiumAlert = self.storyboard?.instantiateViewController(withIdentifier: "purchaseAlertID") as! purchaseAlertViewController
    premiumAlert.purchaseIconString = name
    premiumAlert.providesPresentationContextTransitionStyle = true
    premiumAlert.definesPresentationContext = true
    premiumAlert.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    premiumAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    self.present(premiumAlert, animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

  var list = [SKProduct]()
  var p = SKProduct()

  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    print("product request")
    let myProduct = response.products
    for product in myProduct {
      print("product added")
      print(product.productIdentifier)
      print(product.localizedTitle)
      print(product.localizedDescription)
      print(product.price)

      list.append(product)
    }

  }
  
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction: AnyObject in transactions {
    let trans = transaction as! SKPaymentTransaction
    let t: SKPaymentTransaction = trans
    let prodID = t.payment.productIdentifier as String
      
    switch trans.transactionState {
    case .failed:
      print("buy error")
      queue.finishTransaction(trans)
      break
    case .restored:
      print("\(prodID) Restored!")
      
      queue.finishTransaction(trans)
    //
    default:
      print("Default")
      break
      }
    }
  }
  
  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    for transaction in queue.transactions {
      let t: SKPaymentTransaction = transaction
      let prodID = t.payment.productIdentifier as String
      let defaults = UserDefaults.standard
      
      switch prodID {
      case "com.videoCallPrincess.princessOneEpisodeOne":
        defaults.set(true, forKey: "princessOneEpisodeOne")
      case "com.videoCallPrincess.princessOneEpisodeTwo":
        defaults.set(true, forKey: "princessOneEpisodeTwo")
      case "com.videoCallPrincess.princessOneEpisodeThree":
        defaults.set(true, forKey: "princessOneEpisodeThree")
      case "com.videoCallPrincess.princessTwoEpisodeOne":
        defaults.set(true, forKey: "princessTwoEpisodeOne")
      case "com.videoCallPrincess.princessTwoEpisodeTwo":
        defaults.set(true, forKey: "princessTwoEpisodeTwo")
      case "com.videoCallPrincess.princessTwoEpisodeThree":
        defaults.set(true, forKey: "princessTwoEpisodeThree")
      case "com.videoCallPrincess.princessThreeEpisodeOne":
        defaults.set(true, forKey: "princessThreeEpisodeOne")
      case "com.videoCallPrincess.princessThreeEpisodeTwo":
        defaults.set(true, forKey: "princessThreeEpisodeTwo")
      case "com.videoCallPrincess.princessThreeEpisodeThree":
        defaults.set(true, forKey: "princessThreeEpisodeThree")
      case "com.videoCallPrincess.princessOneAllEpisodes":
        defaults.set(true, forKey: "princessOneAllEpisodes")
      case "com.videoCallPrincess.princessTwoAllEpisodes":
        defaults.set(true, forKey: "princessTwoAllEpisodes")
      case "com.videoCallPrincess.princessThreeAllEpisodes":
        defaults.set(true, forKey: "princessThreeAllEpisodes")
      case "com.videoCallPrincess.Premium":
        defaults.set(true, forKey: "Premium")
      case "com.videoCallPrincess.Deluxe":
        defaults.set(true, forKey: "Deluxe")
      case "com.videoCallPrincess.VIP":
        defaults.set(true, forKey: "VIP")
      default:
        print("IAP not found")
      }
    }
    let alert = UIAlertController(title: "Alert", message: "You've successfully restored your purchases!", preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
      self.viewDidLoad()
      }))
    present(alert, animated: true, completion: nil)
  
  }
    

}

