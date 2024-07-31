//
//  Item.swift
//  FlickrSearchr
//
//  Created by Keith Weiss on 7/30/24.
//

import Foundation

struct FlickrResponse: Codable {
    //  var description: String?
    //  var generator: URL?
    let items: [Item]?
    //  var link: URL?
    //  var modified: Date?
    let title: String
    
    internal init(
        //    description: String?,
        //    generator: URL?,
        items: [Item]?,
        //    link: URL?,
        //    modified: Date?,
        title: String
    ) {
        //    self.description = description
        //    self.generator = generator
        self.items = items
        //    self.link = link
        //    self.modified = modified
        self.title = title
    }
}

extension FlickrResponse {
    struct Item: Codable, Hashable {
        static func == (lhs: FlickrResponse.Item, rhs: FlickrResponse.Item) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        var author: String?
        var authorID: String?
        //    var dateTaken: Date?
        //    var description: String?
        var link: URL?
        var media: Medium?
        var published: Date?
        var tags: String?
        var title: String?
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
            hasher.combine(link)
        }
        
        private enum CodingKeys: String, CodingKey {
            case author
            case authorID = "author_id"
            //      case dateTaken = "date_taken"
            //      case description
            case link
            case media
            case published
            case tags
            case title
        }
        
        internal init(
            author: String?,
            authorID: String?,
            //      dateTaken: Date?,
            //      description: String?,
            link: URL?,
            media: Medium?,
            published: Date?,
            tags: String?,
            title: String?
        ) {
            self.author = author
            self.authorID = authorID
            //      self.dateTaken = dateTaken
            //      self.description = description
            self.link = link
            self.media = media
            self.published = published
            self.tags = tags
            self.title = title
        }
    }
}

extension FlickrResponse.Item {
    struct Medium: Codable {
        var m: URL?
        
        internal init(
            m: URL?
        ) {
            self.m = m
        }
        
        var urlString: String {
            m?.absoluteString ?? ""
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<FlickrResponse.Item.Medium.CodingKeys> = try decoder.container(keyedBy: FlickrResponse.Item.Medium.CodingKeys.self)
            self.m = try container.decodeIfPresent(URL.self, forKey: FlickrResponse.Item.Medium.CodingKeys.m)
        }
    }
}
