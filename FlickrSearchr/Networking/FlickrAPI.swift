//
//  FlickerAPI.swift
//  FlickrSearchr
//
//  Created by Keith Weiss on 7/30/24.
//

import Foundation
import Papyrus

@API
protocol FlickrImages {
    @GET("/feeds/photos_public.gne")
    @JSON(decoder: .iso8601)
    func getFlickrImages(tags: String) async throws -> FlickrResponse
}

// MARK: 1. Create a Provider with any custom configuration.

let provider = Provider(baseURL: "https://api.flickr.com/services")
    .modifyRequests {
        $0.addQuery("format", value: "json")
        $0.addQuery("nojsoncallback", value: "1")
    }
    .intercept { req, next in
        let start = Date()
        let res = try await next(req)
        let elapsedTime = String(format: "%.2fs", Date().timeIntervalSince(start))
        let statusCode = res.statusCode.map { "\($0)" } ?? "N/A"
        print("Got a \(statusCode) for \(req.method) \(req.url!) after \(elapsedTime)")
        return res
    }

extension JSONDecoder {
    static var iso8601: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

// MARK: 2. Initialize an API instance & call an endpoint.



// MARK: 3. Easily mock endpoints for tests.

//let mock = SampleMock()
//mock.mockGetTodos {
//    return [
//        Todo(id: 1, name: "Foo"),
//        Todo(id: 2, name: "Bar"),
//    ]
//}
//
//let mockedTodos = try await mock.getTodos()
