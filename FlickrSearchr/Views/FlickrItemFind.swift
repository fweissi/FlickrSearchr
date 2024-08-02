//
//  FlickrItemFind.swift
//  FlickrSearchr
//
//  Created by Keith Weiss on 7/31/24.
//

import Papyrus
import SwiftUI

struct FlickrItemFind: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    @State private var flickrTitle: String = ""
    @State private var flickrItems: [FlickrResponse.Item] = []
    
    var body: some View {
        NavigationStack {
            Text(flickrTitle).font(.title2)
            List {
                ForEach(flickrItems, id: \.link) { flickrItem in
                    NavigationLink {
                        FlickrItemDetail(flickrItem: flickrItem)
                    } label: {
                        FlickrImage(url: flickrItem.media?.m).scaledToFit()
                            .accessibilityHint(Text("Tap on the image named \(flickrItem.title ?? "untitled") to see more details."))
                    }
                }
            }
            .listStyle(.plain)
            .scrollDismissesKeyboard(.immediately)
            .searchable(text: $searchText, prompt: "find images by tag")
            .onChange(of: searchText) { oldValue, newValue in
                findImages(with: searchText)
            }
            .navigationTitle("Flickr Images")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("Done").bold()
                    }
                }
            }
            .task {
                findImages(with: searchText)
            }
        }
    }
    
    
    private func findImages(with searchText: String) {
        Task {
            let api: FlickrImages = FlickrImagesAPI(provider: provider)
            do {
                let flickrResponse = try await api.getFlickrImages(tags: searchText)
                await setFlickr(response: flickrResponse)
            }
            catch let error as PapyrusError {
                print("Error making request \(String(describing: error.request)): \(error.message). Response was: \(String(describing: error.response))")
            }
            catch {
                print("Papyrus could not decode the JSON: \(error.localizedDescription)")
            }
        }
    }

    
    @MainActor
    private func setFlickr(response: FlickrResponse) {
        flickrTitle = response.title
        flickrItems = response.items ?? []
    }
}

#Preview {
    FlickrItemFind()
}
