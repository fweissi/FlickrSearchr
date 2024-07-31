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
    let title: String
    let width: CGFloat
    let height: CGFloat
    let imageURL: String
    let author: String
    let published: Date
    
    init(
        title: String,
        width: CGFloat,
        height: CGFloat,
        imageURL: String,
        author: String,
        published: Date
    ) {
        self.title = title
        self.width = width
        self.height = height
        self.imageURL = imageURL
        self.author = author
        self.published = published
    }
}
