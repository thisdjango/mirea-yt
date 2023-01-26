// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let playlist = try? newJSONDecoder().decode(Playlist.self, from: jsonData)

import Foundation

// MARK: - Playlist
struct Playlist: Codable {
    let items: [[Item]]
}

// MARK: - Item
struct Item: Codable {
    let id: Int
    let playlistTitle, playlistID: String
    let videoID, name, itemDescription: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case playlistID = "playlist_id"
        case playlistTitle = "playlist_title"
        case videoID = "video_id"
        case name
        case itemDescription = "description"
        case imageURL = "image_url"
    }
}
