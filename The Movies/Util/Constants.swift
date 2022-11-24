//
//  Constants.swift
//  The Movies
//
//  Created by Fabian Hofmann on 01.11.22.
//

import Foundation


/// Global constants.
struct Constants {
    struct Api {
        static let baseUrl: String = "http://www.omdbapi.com"
        static let apiKey: String = "cae4e09c"
        static let searchByIdUrl: String = "\(baseUrl)/?apikey=\(apiKey)&plot=full&i="
        static let searchByTitleUrl: String = "\(baseUrl)/?apikey=\(apiKey)&type=movie&s="
    }
}
