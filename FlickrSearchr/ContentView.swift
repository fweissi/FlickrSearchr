//
//  ContentView.swift
//  FlickrSearchr
//
//  Created by Keith Weiss on 7/30/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var savedFlickrStores : [FlickrStore]
    
    @State private var isShowingRequestDialog: Bool = false
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationSplitView {
            if savedFlickrStores.isEmpty {
                    noContentView
                    .navigationTitle("My Images")
            }
            else {
                List {
                    ForEach(savedFlickrStores.filter({ searchText.isEmpty || $0.title.localizedStandardContains(searchText) })) { flickrStore in
                        NavigationLink {
                            FlickrStoreDetails(flickrStore: flickrStore)
                        } label: {
                            FlickrImage(url: URL(string: flickrStore.imageURL)).scaledToFit()
                                .accessibilityHint(Text("Tap on the image to see more details."))
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .searchable(text: $searchText, prompt: "filter by title")
                .navigationTitle("My Images")
#if os(macOS)
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
                .toolbar {
#if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
#endif
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isShowingRequestDialog.toggle()
                        } label: {
                            Label("Find More Images", systemImage: "magnifyingglass")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        } detail: {
            Text("Select an image")
        }
        .sheet(isPresented: $isShowingRequestDialog) {
            FlickrItemFind()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(savedFlickrStores[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FlickrStore.self, inMemory: true)
}


extension ContentView {
    var noContentView: some View {
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
        }
    }
}
