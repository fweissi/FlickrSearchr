//
//  FlickerItem.swift
//  FlickrSearchr
//
//  Created by Keith Weiss on 7/30/24.
//

import Foundation
import SwiftData

@Model
final class FlickrStore {
    @Attribute(.unique)
    let id: UUID
    var title: String
    var width: CGFloat
    var height: CGFloat
    var imageURL: String
    var author: String
    var published: Date
    
    init(
        id: UUID? = nil,
        title: String,
        width: CGFloat,
        height: CGFloat,
        imageURL: String,
        author: String,
        published: Date
    ) {
        self.id = id ?? UUID()
        self.title = title
        self.width = width
        self.height = height
        self.imageURL = imageURL
        self.author = author
        self.published = published
    }
}
