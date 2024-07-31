//
//  FlickrStoreDetail.swift
//  FlickrSearchr
//
//  Created by Keith Weiss on 7/31/24.
//

import SwiftUI

struct FlickrStoreDetails: View {
    let flickrItem: FlickrStore
    
    var body: some View {
        VStack {
            FlickrImage(url: URL(string: flickrItem.imageURL)).scaledToFit()
            Text(flickrItem.author).font(.subheadline)
            (Text("published: ") +
             Text(flickrItem.published, format: Date.FormatStyle(date: .numeric, time: .standard)))
            .font(.caption)
            .foregroundStyle(.secondary)
            
            Spacer()
        }
        .navigationTitle(flickrItem.title)
    }
}

