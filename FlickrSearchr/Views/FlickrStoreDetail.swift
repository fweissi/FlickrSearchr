//
//  FlickrStoreDetail.swift
//  FlickrSearchr
//
//  Created by Keith Weiss on 7/31/24.
//

import SwiftUI

struct FlickrStoreDetails: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var flickrStore: FlickrStore
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var published: String = ""
    
    private var hasNotChanged: Bool {
        title == flickrStore.title &&
        author == flickrStore.author
    }
    
    var body: some View {
        Form {
            FlickrImage(url: URL(string: flickrStore.imageURL)).scaledToFit()
            HStack {
                Text("Title").font(.caption).bold()
                TextField("Title", text: $title)
            }
            HStack {
                Text("Author").font(.caption).bold()
                TextField("Author", text: $author)
            }
            (Text("published: ") +
             Text(flickrStore.published, format: Date.FormatStyle(date: .numeric, time: .standard)))
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .onChange(of: flickrStore) { oldValue, newValue in
            if oldValue != newValue {
                set(flickrStore: flickrStore)
            }
        }
        .padding()
        .navigationTitle(title)
        .navigationBarBackButtonHidden()
        .onAppear {
            set(flickrStore: flickrStore)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) {
                    if hasNotChanged {
                        dismiss()
                    }
                    else {
                        set(flickrStore: flickrStore)
                    }
                } label: {
                    if hasNotChanged {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back").padding(.leading, -5)
                        }
                    }
                    else {
                        Text("Cancel")
                    }
                }
            }
            
            if !hasNotChanged {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        save(flickrStore: flickrStore)
                    } label: {
                        Text("Save").bold()
                    }
                    .disabled(hasNotChanged)
                }
            }
        }
    }
    
    
    func set(flickrStore: FlickrStore) {
        title = flickrStore.title
        author = flickrStore.author
    }
    
    
    func save(flickrStore: FlickrStore) {
        flickrStore.title = title
        flickrStore.author = author
        
        try? modelContext.save()
    }
}

