//
//  MovieDataPublisher.swift
//  The Movies
//
//  Created by Fabian Hofmann on 01.11.22.
//

import Foundation
import Combine

protocol MovieDataPublisherProtocol {
    var movieApiService: MovieApiServiceProtocol { get }
    func getById(imdbId: String) -> AnyPublisher<MovieModel?, any Error>
    func getAll(searchString: String) -> AnyPublisher<MovieModelSearchResponseModel, any Error>
}

class MovieDataPublisher: ObservableObject, MovieDataPublisherProtocol {
    
    let movieApiService: MovieApiServiceProtocol
    
    // Allow injections for unit tests.
    init(movieApiService: MovieApiServiceProtocol = MovieApiService()) {
        self.movieApiService = movieApiService
    }
    
    /// Fetches results from `MovieApiService.getById` and transformes it into a `MovieModel`.
    ///
    /// - Parameters:
    ///     - imdbId: A valid IMDB id.
    ///
    /// - Returns: An `AnyPublisher` including an optional `MovieModel`.
    ///
    func getById(imdbId: String) -> AnyPublisher<MovieModel?, any Error> {
        return Future({promise in
            self.movieApiService.getById(imdbId: imdbId, completionHandler: {data, _, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(data!))
                }
            })
        })
        .decode(type: (MovieModel?).self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
    
    ///
    /// Fetches all results from `MovieApiService.getAll` for the given `searchString` and transformes them into an list of `MovieModel`.
    ///
    /// - Parameters:
    ///     - imdbId: An IMDB id.
    ///
    /// - Returns: An `AnyPublisher` including `MovieModelSearchResponse`, containing models and the total number of results.
    ///
    func getAll(searchString: String) -> AnyPublisher<MovieModelSearchResponseModel, any Error> {
        return Future({promise in
            self.movieApiService.getAll(searchString: searchString, completionHandler: {data, _, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(data!))
                }
            })
        })
        .decode(type: MovieModelSearchResponseModel.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}
