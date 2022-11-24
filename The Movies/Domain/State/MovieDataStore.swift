//
//  MovieDataStore.swift
//  The Movies
//
//  Created by Fabian Hofmann on 01.11.22.
//

import Foundation
import Combine

protocol MovieDataStoreProtocol {
    var dataPublisher: MovieDataPublisherProtocol { get }
    func getById(imdbId: String) -> Void
    func getAll(searchString: String) -> Void
}

class MovieDataStore: ObservableObject, MovieDataStoreProtocol {
    
    @Published var movies: [MovieModel] = []
    @Published var isLoading: Bool = false
    @Published var totalResults: String = "0"
    @Published var error: Error?
    
    let dataPublisher: MovieDataPublisherProtocol
    var cancellable: AnyCancellable?
    
    // Allow injections for unit tests.
    init(dataPublisher: MovieDataPublisherProtocol = MovieDataPublisher() as! MovieDataPublisherProtocol) {
        self.dataPublisher = dataPublisher
    }
    
    ///
    /// Fetches a `MovieModel` for the provided `imdbId` and updates the result in the internal `$movies`-store. Also publishes errors via `$errors` and updates already stored models with the freshly retrieved data. See `MovieModel.merge` for more information on the merging-process.
    ///
    /// - Parameters:
    ///     - imdbId: An IMDB id.
    ///
    /// - Returns: Void
    ///
    func getById(imdbId: String) -> Void {
        isLoading = true;
        
        // Store the cancellable in order to not destroy the subscription immediately.
        cancellable = dataPublisher
            .getById(imdbId: imdbId)
            .catch({(error) -> Just<MovieModel?> in
                // Don't display errors concerning invalid characters in searchString.
                if let error = error as? HttpError {
                    if (error as! HttpError != HttpError.invalidUrl) {
                        self.error = error
                    }
                }
                return Just(nil)
            })
            .receive(on: RunLoop.main)
            .filter {$0 != nil}
            .map {movieToMerge in
                var tmpMovies = self.movies
                
                // If the movie already exists in the store, update it.
                if let row = tmpMovies
                    .firstIndex(where: {$0.id == imdbId}) {
                        tmpMovies[row] = tmpMovies[row].merge(with: movieToMerge!)
                // Else, append it to the store.
                } else {
                    tmpMovies.append(movieToMerge!)
                }
                self.isLoading = false
                return tmpMovies
            }
            .assign(to: \.movies, on: self)
    }
    
    ///
    /// Fetches all `MovieModel` for the provided `searchString` and completely overwrites the internal `$movies`-store with it.  Also publishes errors via `$errors`.
    ///
    /// - Parameters:
    ///     - searchString: The API filters results according to it.
    ///
    /// - Returns: Void
    ///
    func getAll(searchString: String) -> Void {
        
        // Reset all items in the store
        self.reset();

        isLoading = true;
        
        // Store the cancellable in order to not destroy the subscription immediately.
        cancellable = dataPublisher.getAll(searchString: searchString)
            .receive(on: RunLoop.main)
            .catch({(error) -> Just<MovieModelSearchResponseModel> in
                // Don't display errors concerning invalid characters in searchString.
                if let error = error as? HttpError {
                    if (error as! HttpError != HttpError.invalidUrl) {
                        self.error = error
                    }
                }
                return Just(MovieModelSearchResponseModel(movies: [], totalResults: "0"))
            })
            .map {searchResponse in
                self.totalResults = searchResponse.totalResults
                self.isLoading = false
                return searchResponse.movies
            }
            .assign(to: \.movies, on: self)
    }
    
    ///
    ///
    ///
    func reset() -> Void {
        isLoading = false
        movies = []
        totalResults = "0"
        error = nil
    }
}
