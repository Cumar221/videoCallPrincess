//
//  purchaseAlertViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 4/16/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit
import StoreKit

class purchaseAlertViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
  
  @IBOutlet weak var boxView: UIView!
  @IBOutlet weak var purchaseIconImg: UIImageView!
  @IBOutlet weak var titleLbl: UILabel!
  
  
  var purchaseIconString: String!
  var purchaseType: String!
  
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    purchaseType = "\(purchaseIconString ?? "nil")"
    
    purchaseIconImg.image = UIImage(named: purchaseType)
    
    titleLbl.text = purchaseType + " Upgrade"
    
    if(SKPaymentQueue.canMakePayments()) {
      print("IAP is enabled, loading")
      let productID: NSSet = NSSet(objects: "com.videoCallPrincess." + purchaseType)
      let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
      request.delegate = self
      request.start()
    } else {
      print("please enable IAPS")
    }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupView()
    
    let scale = CGAffineTransform(scaleX: 1.1, y: 1.1)
    
    UIView.animate(withDuration: 0.2, animations: {
      self.boxView.transform = scale
    })
  }
  
  func setupView() {
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
  }
  
  
  
  @IBAction func cancelBtn(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func noThanksBtn(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func purchaseBtn(_ sender: Any) {
    for product in list {
      let prodID = product.productIdentifier
      if(prodID == "com.videoCallPrincess." + purchaseType) {
        p = product
        buyProduct()
      }
    }
  }
  
  
  //
  func buyProduct() {
    print("buy " + p.productIdentifier)
    let pay = SKPayment(product: p)
    SKPaymentQueue.default().add(self)
    SKPaymentQueue.default().add(pay as SKPayment)
  }
  
  func upgradePurchase() {
    let defaults = UserDefaults.standard
    defaults.set(true, forKey: purchaseType)
    self.viewDidLoad()
    // call where the user should go to redeem episodes
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
  
  func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    print("transactions restored")
    for transaction in queue.transactions {
      let t: SKPaymentTransaction = transaction
      let prodID = t.payment.productIdentifier as String
      
      switch prodID {
      case "com.videoCallPrincess." + purchaseType:
        print("remove ads")
        upgradePurchase()
      default:
        print("IAP not found")
      }
    }
  }
  
  func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    print("add payment")
    
    for transaction: AnyObject in transactions {
      let trans = transaction as! SKPaymentTransaction
      print(trans.error)
      
      switch trans.transactionState {
      case .purchased:
        print("buy ok, unlock IAP HERE")
        print(p.productIdentifier)
        
        let prodID = p.productIdentifier
        switch prodID {
        case "com.videoCallPrincess." + purchaseType:
          print("remove ads")
          upgradePurchase()
        default:
          print("IAP not found")
        }
        queue.finishTransaction(trans)
      case .failed:
        print("buy error")
        queue.finishTransaction(trans)
        break
      default:
        print("Default")
        break
      }
    }
  }
  //

}
