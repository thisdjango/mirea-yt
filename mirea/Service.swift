//
//  Service.swift
//  amc-youtube
//
//  Created by thisdjango on 14.02.2020.
//  Copyright © 2020 thisdjango. All rights reserved.
//

import UIKit

class Service {

    struct LocalVideoInfo {
        var id: [String] = []
        var images: [UIImage] = []
        var titles: [String] = []
        var description: [String] = []
    }

    static let shared = Service()

    private let TOKEN = CDATA().TOKEN
    private let CHANNELID = CDATA().CHANNELID

    var playlistsData: [Item] = []
    var labels: [String] = []
    var videos: [Videos] = []
    var videoInfo: [LocalVideoInfo] = []
    var local = LocalVideoInfo()
    
    func clear() {
        playlistsData.removeAll()
        labels.removeAll()
        videos.removeAll()
        videoInfo.removeAll()
        
        local.id.removeAll()
        local.images.removeAll()
        local.description.removeAll()
        local.titles.removeAll()
    }
    
    func grabPlaylistsData(completionHandler: @escaping (_ playlists: [Item]?) -> ()) {
        
        let PLAYLIST_URL_LINK = "https://www.googleapis.com/youtube/v3/playlists?part=snippet&channelId=\(CHANNELID)&maxResults=50&key=\(TOKEN)"
        print(PLAYLIST_URL_LINK)
        
        guard let url = URL(string: PLAYLIST_URL_LINK) else {
            print("unlucky :(")
            completionHandler(nil)
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print(error?.localizedDescription ?? "no description for error provided!\n")
                return
            }

            guard let data = data else { return }
            do {
                let playlist = try JSONDecoder().decode(Playlist.self, from: data)
                
                // saving playlists to array
                self.playlistsData = playlist.items
                completionHandler(playlist.items)
            } catch let decodingError as DecodingError {
                print("Error: can't parse gists")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                print(decodingError)
            } catch {
                print("Unknown Error: can't parse gists")
            }
        }
        
        task.resume()
    }
    
    func grabTitleAndVideos(for playlist: Item, completionHandler: @escaping (_ videos: Videos?) -> ()) {
            
        //Videos
        let VIDEOS_URL_LINK = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=\(playlist.id)&key=\(TOKEN)"
        print(VIDEOS_URL_LINK)
        
        guard let url = URL(string: VIDEOS_URL_LINK) else {
            print("getVideos unlucky")
            completionHandler(nil)
            return
        }
            
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
            guard error == nil else {
                print(error?.localizedDescription ?? "no description for error provided!\n")
                completionHandler(nil)
                return
            }
                
            guard let data = data else {
                completionHandler(nil)
                return
            }
            
            guard let videos = try? JSONDecoder().decode(Videos.self, from: data) else {
                print("Error: can't parse videos.")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                completionHandler(nil)
                return
            }
            
            self.videos.append(videos)
            
            // Grab Title
            self.labels.append(playlist.snippet.title)
            
            // Расскоментируй ниже, что бы посмотреть как работает загрузка данных
            //print(self.videos.count, "Task for \"\(playlist.snippet.title)\" is ready. Videos \(videos.items.count)")
            completionHandler(videos)
        }
        
        task.resume()
    }
    
    func grabMediaContent(for videos: Videos, completionHandler: @escaping (_ success: Bool) -> ()) {
        
        for video in videos.items {
            guard let urlString = video.snippet.thumbnails.high?.url,
                  let url = URL(string: urlString) else {
                continue
            }
            
            DispatchQueue.global(qos: .userInteractive).sync {
                var soLocalImage = UIImage(named: "image-placeholder")!
                if let data = try? Data(contentsOf: url){
                    if let image = UIImage(data: data){ soLocalImage = image }
                }
                local.id.append(video.snippet.resourceID.videoID)
                local.images.append(soLocalImage)
                local.description.append(video.snippet.snippetDescription)
                local.titles.append(video.snippet.title)
            }
        }
        videoInfo.append(local)
        local.id.removeAll()
        local.images.removeAll()
        local.description.removeAll()
        local.titles.removeAll()
        completionHandler(true)
    }
}
