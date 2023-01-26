//
//  TableViewCell.swift
//  amc-youtube
//
//  Created by thisdjango on 29.01.2020.
//  Copyright © 2020 thisdjango. All rights reserved.
//

import UIKit

protocol TableViewDelegate{
    func didSendInfo(_ titleV: String, for video_id: String, descr: String)
}

class TableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tableViewlDelegate: TableViewDelegate?
    var playlistID: Int?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mytitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionViewDataSourceDelegate(self)
    }
    
    func reloadCollectionView() {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let playlistID = playlistID else {
            return 0
        }
        return Service.shared.playlistGroups[playlistID].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! CollectionViewCell
        guard let playlistID = playlistID else {
            return UICollectionViewCell()
        }
        let id = Service.shared.playlistGroups[playlistID][indexPath.row].id
        myCell.myimage.image = Service.shared.images[id]
        myCell.mylabel.text = Service.shared.playlistGroups[playlistID][indexPath.row].name

        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let playlistID = playlistID else {
            return
        }
        let video = Service.shared.playlistGroups[playlistID][indexPath.row]
        tableViewlDelegate?.didSendInfo(video.name, for: video.videoID, descr: video.itemDescription)
    }
}

extension TableViewCell {
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate: D)
    {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.reloadData()
    }
}
