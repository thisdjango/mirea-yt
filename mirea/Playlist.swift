// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let playlist = try? newJSONDecoder().decode(Playlist.self, from: jsonData)

import Foundation

// MARK: - Playlist
struct Playlist: Codable {
    let kind, etag: String
    let pageInfo: PageInfo
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let kind: Kind
    let etag, id: String
    let snippet: Snippet
}

enum Kind: String, Codable {
    case youtubePlaylist = "youtube#playlist"
}

// MARK: - Snippet
struct Snippet: Codable {
    let publishedAt: String
    let channelID: String
    let title, snippetDescription: String
    let thumbnails: Thumbnails
    let channelTitle: String
    let localized: Localized
    let defaultLanguage: String?

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title
        case snippetDescription = "description"
        case thumbnails, channelTitle, localized, defaultLanguage
    }
}

// MARK: - Localized
struct Localized: Codable {
    let title, localizedDescription: String

    enum CodingKeys: String, CodingKey {
        case title
        case localizedDescription = "description"
    }
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let thumbnailsDefault, medium, high: Default
    let standard, maxres: Default?

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high, standard, maxres
    }
}

// MARK: - Default
struct Default: Codable {
    let url: String
    let width, height: Int
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults, resultsPerPage: Int
}
