//
//  PreviewViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 7/4/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit
import StoreKit


class PreviewViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    weak var delegate: SecondViewControllerDelegate?
    
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var firstDiscription: UILabel!
    @IBOutlet weak var secondDiscription: UILabel!
    
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    
    @IBOutlet weak var videoView: UIView!
    
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var videoName: String!
    
    
    
    @IBOutlet weak var replayLbl: UILabel!
    
    var princessName: String!
    var princessNumber: String!
    var episodeNumber: String!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueVideo" {
            let controller = segue.destination as! IncomingVideoViewController
            controller.videoName = videoName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PreviewViewController.playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        if "\(episodeNumber ?? "nil")" == "One" {
            firstLbl.text = "Introduction"
            firstDiscription.text = "That first magical video call from " + "\(princessName ?? "nil")"
            
        } else if "\(episodeNumber ?? "nil")" == "Two" {
            firstLbl.text = "I Can't Wait to See You!"
            firstDiscription.text = "When you’re on your way to visit " + "\(princessName ?? "nil")" + " at a theme park"
            
        } else {
            firstLbl.text = "Happy Birthday!"
            firstDiscription.text = "A call from " + "\(princessName ?? "nil")" + " wishing you a happy birthday"
            
        }
        
        videoName = "\(princessNumber ?? "nil")" + "Episode" + "\(episodeNumber ?? "nil")"
        secondDiscription.text = "All current and future episodes of " + "\(princessName ?? "nil")"
        
        setupVideo()
        playVideo()
        
        videoView.layer.cornerRadius = 5
        videoView.layer.masksToBounds = true
        
        //
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID: NSSet = NSSet(objects: "com.videoCallPrincess." + "\(princessNumber ?? "nil")" + "Episode" + "\(episodeNumber ?? "nil")", "com.videoCallPrincess." + "\(princessNumber ?? "nil")" + "AllEpisodes")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
        
        let episodePurchaseConstant = "\(princessNumber ?? "nil")" + "Episode" + "\(episodeNumber ?? "nil")"
        let allEpisodesConstant = "\(princessNumber ?? "nil")" + "AllEpisodes"
        
        let defaults = UserDefaults.standard
        
        if (defaults.bool(forKey: allEpisodesConstant)) == true {
            
            firstBtn.setTitle("Incoming Call", for: .normal)
            secondBtn.setTitle("Paid!", for: .normal)
            
        } else if (defaults.bool(forKey: episodePurchaseConstant)) == true {
            firstBtn.setTitle("Incoming Call", for: .normal)
        } else {
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func setupVideo() {
        guard let url = Bundle.main.path(forResource: videoName, ofType: "mp4") else {
            debugPrint("Video not found")
            return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: url))
        playerLayer = AVPlayerLayer(player: player)
        
        videoView.layer.addSublayer(playerLayer)
        
        playerLayer.frame = videoView.bounds
    }
    
    func playVideo() {
        let seconds : Int64 = 0
        let preferredTimeScale : Int32 = 1
        let seekTime : CMTime = CMTimeMake(seconds, preferredTimeScale)
        
        player.seek(to: seekTime)
        player.play()
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        delegate?.settingsUpdated(light: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rightNextBtnPressed(_ sender: Any) {
    }
    
    @IBAction func leftNextBtnPressed(_ sender: Any) {
    }
    
    @IBAction func firstBtnPressed(_ sender: Any) {
        
        player.pause()
        
        let episodePurchaseConstant = "\(princessNumber ?? "nil")" + "Episode" + "\(episodeNumber ?? "nil")"
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: episodePurchaseConstant)) {
            performSegue(withIdentifier: "segueVideo", sender: self)
        } else {
            for product in list {
                let prodID = product.productIdentifier
                if(prodID == "com.videoCallPrincess." + episodePurchaseConstant) {
                    p = product
                    buyProduct()
                }
            }
        }
    }
    
    @IBAction func secondBtnPressed(_ sender: Any) {
        
        player.pause()
        
        let allEpisodesConstant = "\(princessNumber ?? "nil")" + "AllEpisodes"
        let defaults = UserDefaults.standard
        if (defaults.bool(forKey: allEpisodesConstant)) {
            print("All Episodes Already Purchased")
        } else {
            for product in list {
                let prodID = product.productIdentifier
                if(prodID == "com.videoCallPrincess." + allEpisodesConstant) {
                    p = product
                    buyProduct()
                }
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
    
    func episodeTwoPurchase() {
        let episodePurchaseConstant = "\(princessNumber ?? "nil")" + "Episode" + "\(episodeNumber ?? "nil")"
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: episodePurchaseConstant)
        
        firstBtn.setTitle("Incoming Call", for: .normal)
    }
    
    func allEpisodesPurchased() {
        let allEpisodesConstant = "\(princessNumber ?? "nil")" + "AllEpisodes"
        let episodeOnePurchaseConstant = "\(princessNumber ?? "nil")" + "EpisodeOne"
        let episodeTwoPurchaseConstant = "\(princessNumber ?? "nil")" + "EpisodeTwo"
        let episodeThreePurchaseConstant = "\(princessNumber ?? "nil")" + "EpisodeThree"
        let episodeFourPurchaseConstant = "\(princessNumber ?? "nil")" + "EpisodeFour"
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: allEpisodesConstant)
        defaults.set(true, forKey: episodeOnePurchaseConstant)
        defaults.set(true, forKey: episodeTwoPurchaseConstant)
        defaults.set(true, forKey: episodeThreePurchaseConstant)
        defaults.set(true, forKey: episodeFourPurchaseConstant)
        
        firstBtn.setTitle("Incoming Call", for: .normal)
        secondBtn.setTitle("Paid!", for: .normal)
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
        print("add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            
            switch trans.transactionState {
            case .purchased:
                print("buy ok, unlock IAP HERE")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier
                switch prodID {
                case "com.videoCallPrincess." + "\(princessNumber ?? "nil")" + "Episode" + "\(episodeNumber ?? "nil")":
                    print("remove ads")
                    episodeTwoPurchase()
                case "com.videoCallPrincess." + "\(princessNumber ?? "nil")" + "AllEpisodes":
                    print("add coins to account")
                    allEpisodesPurchased()
                default:
                    print("IAP not found")
                }
                queue.finishTransaction(trans)
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break
            case .restored:
                print("Already Purchased")
                
                queue.finishTransaction(trans)
            //
            default:
                print("Default")
                break
                
            }
        }
    }
    //
    
    @IBAction func playBtnPressed(_ sender: Any) {
        playBtn.isHidden = true
        replayLbl.isHidden = true
        pauseBtn.isHidden = false
        playVideo()
        
    }
    
    @IBAction func pauseBtnPressed(_ sender: Any) {
        playBtn.isHidden = false
        replayLbl.isHidden = false
        pauseBtn.isHidden = true
        player.pause()
        
        
    }
    
    
    @objc func playerDidFinishPlaying() {
        playBtn.isHidden = false
        replayLbl.isHidden = false
        pauseBtn.isHidden = true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
