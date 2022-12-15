import Foundation

// MARK: - Videos
struct Videos: Codable {
    let kind, etag: String
    let items: [ItemVideo]
    let pageInfo: PageInfoVideo
}

// MARK: - Item
struct ItemVideo: Codable {
    let kind: ItemKind
    let etag, id: String
    let snippet: SnippetVideo
}

enum ItemKind: String, Codable {
    case youtubePlaylistItem = "youtube#playlistItem"
}

// MARK: - Snippet
struct SnippetVideo: Codable {
    let publishedAt: String
    let channelID: String
    let title, snippetDescription: String
    let thumbnails: ThumbnailsVideo
    let channelTitle: String
    let playlistID: String
    let position: Int
    let resourceID: ResourceID
    let videoOwnerChannelTitle: String?
    let videoOwnerChannelID: String?

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title
        case snippetDescription = "description"
        case thumbnails, channelTitle
        case playlistID = "playlistId"
        case position
        case resourceID = "resourceId"
        case videoOwnerChannelTitle
        case videoOwnerChannelID = "videoOwnerChannelId"
    }
}

// MARK: - ResourceID
struct ResourceID: Codable {
    let kind: ResourceIDKind
    let videoID: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}

enum ResourceIDKind: String, Codable {
    case youtubeVideo = "youtube#video"
}

// MARK: - Thumbnails
struct ThumbnailsVideo: Codable {
    let thumbnailsDefault, medium, high, standard: DefaultVideo?
    let maxres: DefaultVideo?

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high, standard, maxres
    }
}

// MARK: - Default
struct DefaultVideo: Codable {
    let url: String
    let width, height: Int
}

// MARK: - PageInfo
struct PageInfoVideo: Codable {
    let totalResults, resultsPerPage: Int
}
