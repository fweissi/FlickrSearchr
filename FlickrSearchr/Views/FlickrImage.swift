//
//  FlickrImage.swift
//  FlickrSearchr
//
//  Created by Keith Weiss on 7/31/24.
//

import Kingfisher
import SwiftUI

struct FlickrImage: View {
    let url: URL?
    
    @Binding var imageSize: CGSize
    
    init(url: URL?, imageSize: Binding<CGSize>? = nil) {
        self.url = url
        _imageSize = imageSize ?? .constant(.zero)
    }
    
    var body: some View {
        if let url {
            KFImage(url)
                .resizable()
                .placeholder({
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(.secondary)
                })
                .roundCorner(radius: .point(12.0))
                .fade(duration: 0.25)
                .onSuccess { result in imageSize = result.image.size }
                .onFailure { error in print("Error: \(error)") }
        }
    }
}
