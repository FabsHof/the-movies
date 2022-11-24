//
//  MovieModelSearchResponseModel.swift
//  The Movies
//
//  Created by Fabian Hofmann on 02.11.22.
//

import Foundation

struct MovieModelSearchResponseModel: Decodable {
    var movies: [MovieModel]
    var totalResults: String
    
    /// Used for de-/encoding between model and JSON
    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults = "totalResults"
    }
}
