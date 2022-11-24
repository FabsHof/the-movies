//
//  MovieApiService.swift
//  The Movies
//
//  Created by Fabian Hofmann on 02.11.22.
//

import Foundation
import Combine

protocol MovieApiServiceProtocol {
    var session: URLSession { get }
    func getById(imdbId: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void
    func getAll(searchString: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void
}

class MovieApiService: ObservableObject, MovieApiServiceProtocol {
    
    let session: URLSession
    
    // Allow injections for unit tests.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    ///
    /// Retrieves movie data from API for the given imdb id.
    ///
    /// - Parameters:
    ///     - imdbId: A search string to filter movie-data from API.
    ///     - completionHandler: A callback when data task completes, including the payload data, URLResponse of the call and possible errors.
    ///
    /// - Returns: Void
    ///
    func getById(imdbId: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        let str: String = "\(Constants.Api.searchByIdUrl)\(imdbId)"
        let urlComponents =  URLComponents(string: str)
        guard let url = URLComponents(string: str)?.url else {
            completionHandler(nil, nil, HttpError.invalidUrl)
            return
        }
        
        let urlSession = session.dataTask(with: url) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                // Display custom unauthorized errors for status 401
                if (httpResponse.statusCode == 401) {
                    completionHandler(data, response, HttpError.unauthorized)
                    return
                }
            }
            completionHandler(data, response, error)
        }
        urlSession.resume()
    }
    
    ///
    /// Retrieves movie data from API for the given searchString.
    ///
    /// - Parameters:
    ///     - searchString: A search string to filter movie-data from API.
    ///     - completionHandler: A callback when data task completes, including the payload data, URLResponse of the call and possible errors.
    ///
    /// - Returns: Void
    ///
    func getAll(searchString: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        let str: String = "\(Constants.Api.searchByTitleUrl)\(searchString)"
        let urlComponents =  URLComponents(string: str)
        guard let url = URLComponents(string: str)?.url else {
            completionHandler(nil, nil, HttpError.invalidUrl)
            return
        }
        
        let urlSession = session.dataTask(with: url) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                // Display custom unauthorized errors for status 401
                if (httpResponse.statusCode == 401) {
                    completionHandler(data, response, HttpError.unauthorized)
                    return
                }
            }
            completionHandler(data, response, error)
        }
        urlSession.resume()
    }
    
}
