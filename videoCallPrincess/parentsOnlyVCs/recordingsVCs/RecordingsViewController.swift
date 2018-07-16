//
//  RecordingsViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 1/29/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol VideoTableViewCellDelegate : class {
    
    func shareVideo(senderCell: VideoCellTableViewCell, shareVideoURL: URL, silentVideoName: String)
    func deleteVideo(senderCell: VideoCellTableViewCell, deleteVideoURL: URL)
}

class RecordingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VideoTableViewCellDelegate{
    
    
    func shareVideo(senderCell: VideoCellTableViewCell, shareVideoURL: URL, silentVideoName: String) {
        
        shareVideoURLFinal = shareVideoURL
        silentVideoNameFinal = silentVideoName
        
        
        let shareAlert = self.storyboard?.instantiateViewController(withIdentifier: "shareAlertAlertID") as! ShareViewController
        shareAlert.providesPresentationContextTransitionStyle = true
        shareAlert.definesPresentationContext = true
        shareAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        shareAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        shareAlert.delegate = self
        self.present(shareAlert, animated: true, completion: nil)
        
        
    }
    
    func deleteVideo(senderCell: VideoCellTableViewCell, deleteVideoURL: URL) {
        
        let alert = UIAlertController(title: "Alert", message: "Would you like to delete this video?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in
            
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(at: deleteVideoURL)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
            
            if let indexPath = self.tableView.indexPath(for: senderCell) {
                self.urls.remove(at: indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.endUpdates()
                
                if self.urls.count == 0 {
                    self.noRecordingsView.isHidden = false
                } else {
                    self.noRecordingsView.isHidden = true
                }
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noRecordingsView: UIView!
    
    fileprivate var tasks = [URLSessionTask]()
    
    var urls: [URL] = []
    var cells: [Int: VideoCellTableViewCell] = [:]
    var shareVideoURLFinal: URL!
    var silentVideoNameFinal: String!
    var verticalSelected = true
    var isDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadList(_:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: [.contentModificationDateKey], options: [.skipsHiddenFiles])
            
            let movFiles = directoryContents.filter{ $0.pathExtension == "mov" }
            print("mov urls:", movFiles)
            
            
            let temp = directoryContents.map { url in
                (url, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
                }
                .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
                .map { $0.0 } // extract file names
            
            self.urls = temp
            self.tableView.reloadData()
            
            if movFiles.isEmpty == true {
                noRecordingsView.isHidden = false
            } else {
                noRecordingsView.isHidden = true
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
        let destinationPath = documentsPath.appendingPathComponent("overlapVideo.mov")
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: destinationPath) {
            do {
                try fileManager.removeItem(atPath: destinationPath)
                print("Deleted Overlap Video")
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        } else {
            print("Overlap file does not exist")
        }
    }
    
    @objc func loadList(_ notification: NSNotification){
        //load data here
        viewDidLoad()
        print("notification received")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.urls.count
    }
    
    fileprivate func cancelPrefetchVideo(forItemAtIndex index: Int) {
        let url = self.urls[index]
        guard let taskIndex = tasks.index(where: { $0.originalRequest?.url == url }) else {
            return
        }
        
        self.cells[index] = nil
        let task = tasks[taskIndex]
        task.cancel()
        tasks.remove(at: taskIndex)
    }

    
    fileprivate func prefetchVideo(forItemAtIndex index: Int) {
        let url = self.urls[index]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! VideoCellTableViewCell
        
        
        guard tasks.index(where: { $0.originalRequest?.url == url }) == nil else {
            // We're already downloading the image.
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                cell.url = url
                cell.delegate = self
                cell.setupVideo()
                
                DispatchQueue.global(qos: .userInteractive).async {
                    let player = AVPlayer(url: cell.url)
                    let silentURL: NSURL = Bundle.main.url(forResource: "princessOneEpisodeOne", withExtension: "mp4")! as NSURL
                    let silentPlayer = AVPlayer(url: silentURL as URL)
                    let silentLayer = AVPlayerLayer(player: silentPlayer)
                   
                    
                    DispatchQueue.main.async {
                        cell.videoView?.playerLayer.player = player
                        cell.silentVideoView?.playerLayer.player = silentLayer.player
                    }
                }
                    
                self.cells[index] = cell
                
                let indexPath = IndexPath(row: index, section: 0)
                if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    
                }
            }
        }
        
        task.resume()
        tasks.append(task)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! VideoCellTableViewCell
        
        if self.cells.index(forKey: indexPath.row) == nil{
            self.prefetchVideo(forItemAtIndex: indexPath.row)
            
        }
        else{
            cell = self.cells[indexPath.row]!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 479
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension RecordingsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { self.prefetchVideo(forItemAtIndex: $0.row) }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        //indexPaths.forEach { self.cancelPrefetchVideo(forItemAtIndex: $0.row) }
    }
}

extension RecordingsViewController: ShareViewDelegate {
    func cancelBtnAction() {
        verticalSelected = true
    }
    
    func verticalBtnAction() {
        verticalSelected = true
    }
    
    func boxBtnAction() {
        verticalSelected = false
    }
    
    func shareBtnAction() {
        let silentPath = Bundle.main.path(forResource: silentVideoNameFinal, ofType: "mp4")!
        let silentUrl = URL.init(fileURLWithPath: silentPath)
        
        print("\(silentVideoNameFinal)")

        let exporter = AVAssetExportSession.overlapVideos(shareVideoURLFinal,
                                                          secondUrl: silentUrl,
                                                          isPortraitMode: verticalSelected,
                                                          exportedFilename: "overlapVideo.mov")
        
        exporter?.exportAsynchronously {
            DispatchQueue.main.async {
                
                let activityVC = UIActivityViewController(activityItems: [exporter?.outputURL ?? self.shareVideoURLFinal], applicationActivities: nil)
                
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
                self.isDone = true
            }
        }
        
        if isDone == true {
            isDone = false
            verticalSelected = true
            
        }
    }
}
