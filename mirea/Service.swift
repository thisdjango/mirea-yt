//
//  Service.swift
//  amc-youtube
//
//  Created by thisdjango on 14.02.2020.
//  Copyright © 2020 thisdjango. All rights reserved.
//

import UIKit

class Service {

    static let shared = Service()

    private let TOKEN = CDATA().TOKEN
    private let CHANNELID = CDATA().CHANNELID

    var images: [Int: UIImage] = [:]
    var playlistGroups = [[Item]]()
    
    func clear() {
        images.removeAll()
        playlistGroups.removeAll()
    }
    
    func grabPlaylistsData(completionHandler: @escaping (_ playlists: Playlist?) -> ()) {
        
        let PLAYLIST_URL_LINK = "http://127.0.0.1:8000/video/"

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
                self.playlistGroups = playlist.items
                completionHandler(playlist)
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

    func grabMediaContent(for playlists: Playlist, completionHandler: @escaping (_ success: Bool) -> ()) {
        for playlist in playlists.items {
            for video in playlist {
                let urlString = video.imageURL
                guard let url = URL(string: urlString) else {
                    continue
                }
                
                DispatchQueue.global(qos: .userInteractive).sync {
                    var soLocalImage = UIImage(named: "image-placeholder")!
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) { soLocalImage = image }
                    }
                    images[video.id] = soLocalImage
                }
            }
        }
        completionHandler(true)
    }

}
