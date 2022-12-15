//
//  TableViewController.swift
//  amc-youtube
//
//  Created by thisdjango on 28.01.2020.
//  Copyright © 2020 thisdjango. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let myGroup = DispatchGroup()
    var sendTitleVideo = String()
    var sendIdVideo = String()
    var sendDescVideo = String()
    let refresh = UIRefreshControl()

    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "blob-scene-haikei.png"))
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loadData()
        myGroup.notify(queue: .main) {
            self.loader.isHidden = true
            self.refresh.endRefreshing()
            self.tableView.reloadData()
        }
        
        refresh.attributedTitle = NSAttributedString(string: "Обновляю. Минутку..")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        tableView.refreshControl = refresh
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Service.shared.playlistsData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idcell", for: indexPath) as! TableViewCell
        cell.currentIndexPath = indexPath

        cell.mytitle.text = Service.shared.labels[indexPath.row]
        cell.selectionStyle = .none
        cell.tableViewlDelegate = self
        cell.reloadCollectionView()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toVideo"{
            let nextVC = segue.destination as! VideoViewController
            nextVC.titleVideo = sendTitleVideo
            nextVC.idVideo = sendIdVideo
            nextVC.descVideo = sendDescVideo
        }
    }

    @objc
    func loadData() {
        Service.shared.clear()
        myGroup.enter()

        Service.shared.grabPlaylistsData { (playlists) in
            guard let playlists = playlists else { return }
            
            for playlist in playlists {
                Service.shared.grabTitleAndVideos(for: playlist) { (videos) in
                    guard let videos = videos else { return }
                    
                    Service.shared.grabMediaContent(for: videos) { (success) in
                        
                        if success && Service.shared.videoInfo.count == Service.shared.playlistsData.count {
                            self.myGroup.leave()
                        }
                    }
                }
            }
        }
    }
}

extension TableViewController: TableViewDelegate {
    func didSendInfo(_ titleV: String, for video_id: String, descr: String) {
        sendTitleVideo = titleV
        sendIdVideo = video_id
        sendDescVideo = descr
        performSegue(withIdentifier: "toVideo", sender: nil)
    }
}

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

