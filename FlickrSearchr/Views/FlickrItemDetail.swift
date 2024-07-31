//
//  FlickrItemDetail.swift
//  FlickrSearchr
//
//  Created by Keith Weiss on 7/31/24.
//

import SwiftUI

struct FlickrItemDetail: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let flickrItem: FlickrResponse.Item
    
    @State private var imageSize: CGSize = .zero
    
    var body: some View {
        VStack(alignment: .leading) {
            FlickrImage(url: flickrItem.media?.m, imageSize: $imageSize)
                .scaledToFit()
            
            Text(flickrItem.title ?? "unknown title")
                .font(.headline)
            Text(flickrItem.author ?? "unknown author")
                .font(.subheadline)
            Text("image size: (w: \(imageSize.width), h: \(imageSize.height))")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if let publishedDate = flickrItem.published {
                (Text("published: ") +
                 Text(publishedDate, format: Date.FormatStyle(date: .numeric, time: .standard)))
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                save(flickrItem: flickrItem)
            } label: {
                Label("Save to my images", systemImage: "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal)
        .navigationTitle(flickrItem.title ?? "unknown title")
    }
    
    
    private func save(flickrItem: FlickrResponse.Item) {
        withAnimation {
            let item = FlickrStore(
                title: flickrItem.title ?? "",
                width: imageSize.width,
                height: imageSize.height,
                imageURL: flickrItem.media?.urlString ?? "",
                author: flickrItem.author ?? "",
                published: flickrItem.published ?? .distantPast
            )
            
            modelContext.insert(item)
            
            dismiss()
        }
    }
}

#Preview {
    FlickrItemDetail(
        flickrItem: FlickrResponse.Item(
            author: "Author's Name",
            authorID: "Doesn't Really Matter",
            link: URL(string: "https://www.flickr.com/photos/jules5691/53808657053/")!,
            media: FlickrResponse.Item.Medium(m: URL(string: "https://live.staticflickr.com/65535/53808657053_efe64b8eb5_m.jpg")),
            published: Date(),
            tags: "tagA, tagB",
            title: "A Test Image for Design"
        )
    )
}
