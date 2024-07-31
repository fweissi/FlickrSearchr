//
//  ContentView.swift
//  FlickrSearchr
//
//  Created by Keith Weiss on 7/30/24.
//

import Kingfisher
import Papyrus
import SwiftUI
import SwiftData

struct ContentView: View {
    let processor = DownsamplingImageProcessor(size: CGSize(width: 500, height: 280))
                 |> RoundCornerImageProcessor(cornerRadius: 20)
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var savedFlickrItems : [FlickrStore]
    
    @State private var isShowingRequestDialog: Bool = false
    @State private var searchText: String = ""
    @State private var flickrTitle: String = ""
    @State private var flickrItems: [FlickrResponse.Item] = []
    @State private var selectedFlickrItem: FlickrResponse.Item?
    
    var body: some View {
        NavigationSplitView {
            if savedFlickrItems.isEmpty {
                if flickrItems.isEmpty {
                    ContentUnavailableView {
                        Label("Select an Image", systemImage: "photo.on.rectangle.angled")
                    } description: {
                        Text("You might need to find some images first.")
                    } actions: {
                        Button {
                            isShowingRequestDialog.toggle()
                        } label: {
                            Label("Find some images", systemImage: "magnifyingglass")
                        }
                        .alert(
                            Text("Search Flckr for Images"),
                            isPresented: $isShowingRequestDialog
                        ) {
                            Button("Cancel", role: .cancel) {}
                            Button("Find images") { findImages() }
                            
                            TextField("tags", text: $searchText)
                                .textInputAutocapitalization(.never)
                        } message: {
                            Text("Enter a tag or several tags separated with a comma. Example: woodland, animals")
                        }
                    }
                    .navigationTitle("Saved Images")
                }
                else {
                    VStack {
                        Text(flickrTitle).font(.title2)
                        List {
                            ForEach(flickrItems, id: \.link) { flickrItem in
                                VStack(alignment: .leading) {
                                    if let url = flickrItem.media?.m {
                                        KFImage(url)
                                            .placeholder({
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .frame(width: 36, height: 36)
                                            })
                                            .setProcessor(processor)
                                            .loadDiskFileSynchronously()
                                            .cacheMemoryOnly()
                                            .fade(duration: 0.25)
//                                            .lowDataModeSource(.network(lowResolutionURL))
                                            .onProgress { receivedSize, totalSize in print("received: \(receivedSize)") }
                                            .onSuccess { result in print("Image loaded from cache: \(result.cacheType)") }
                                            .onFailure { error in print("Error: \(error)") }
                                    }
                                    Text(flickrItem.title ?? "unknown title")
                                        .font(.headline)
                                    Text(flickrItem.author ?? "unknown author")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    if let publishedDate = flickrItem.published {
                                        (Text("published: ") +
                                         Text(publishedDate, format: Date.FormatStyle(date: .numeric, time: .standard)))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    }
                                }
                                .background(Rectangle().fill(flickrItem == selectedFlickrItem ? Color.accentColor.opacity(0.15) : Color.clear))
                                .onTapGesture { select(flickrItem: flickrItem) }
                            }
                        }
                    }
                    .navigationTitle("Select an image")
                    .toolbar(content: {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                if let selectedFlickrItem {
                                    save(flickrItem: selectedFlickrItem)
                                }
                            } label: {
                                Label("Save", systemImage: "square.and.arrow.down")
                            }
                            .buttonStyle(.bordered)
                            .disabled(selectedFlickrItem == nil)
                        }
                    })
                }
            }
            else {
                List {
                    ForEach(savedFlickrItems) { flickrItem in
                        NavigationLink {
                            VStack {
                                Text(flickrItem.author)
                                Text(flickrItem.published, format: Date.FormatStyle(date: .numeric, time: .standard))
                            }
                            .navigationTitle(flickrItem.title)
                        } label: {
                            VStack {
                                Text(flickrItem.title)
                                Text(flickrItem.published, format: Date.FormatStyle(date: .numeric, time: .standard))
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
#if os(macOS)
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
                .toolbar {
#if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
#endif
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(savedFlickrItems[index])
            }
        }
    }
    
    
    private func select(flickrItem: FlickrResponse.Item) {
        if selectedFlickrItem == flickrItem {
            selectedFlickrItem = nil
        }
        else {
            selectedFlickrItem = flickrItem
        }
    }
    
    private func save(flickrItem: FlickrResponse.Item) {
        withAnimation {
            
            let item = FlickrStore(
                title: flickrItem.title ?? "",
                width: 300,
                height: 150,
                imageURL: flickrItem.media?.urlString ?? "",
                author: flickrItem.author ?? "",
                published: flickrItem.published ?? .distantPast
            )
            
            modelContext.insert(item)
        }
    }
    
    private func findImages() {
        print("Find some images")
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
    ContentView()
        .modelContainer(for: FlickrStore.self, inMemory: true)
}
