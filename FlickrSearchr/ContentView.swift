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
    
    @Query private var savedFlickrItems : [FlickrStore]
    
    @State private var isShowingRequestDialog: Bool = false
    
    var body: some View {
        NavigationSplitView {
            if savedFlickrItems.isEmpty {
                    noContentView
                    .navigationTitle("My Images")
            }
            else {
                List {
                    ForEach(savedFlickrItems) { flickrItem in
                        NavigationLink {
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
                        } label: {
                            FlickrImage(url: URL(string: flickrItem.imageURL)).scaledToFit()
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
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
            Text("Select an item")
        }
        .sheet(isPresented: $isShowingRequestDialog) {
            FlickrItemFind()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(savedFlickrItems[index])
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
