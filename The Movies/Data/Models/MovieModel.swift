//
//  Movie.swift
//  The Movies
//
//  Created by Fabian Hofmann on 01.11.22.
//

import Foundation

struct MovieModel: Identifiable, Decodable {
    var id: String?
    var title: String?
    var year: String?
    var genre: String?
    var actors: String?
    var director: String?
    var plot: String?
    var posterUrl: String?
    
    // Used for de-/encoding between model and JSON
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case genre = "Genre"
        case actors = "Actors"
        case director = "Director"
        case plot = "Plot"
        case posterUrl = "Poster"
    }
    
    ///
    /// Allows it to merge two moviemodels concerning their properties. Prioritizes values over empty fields, as well as own properties over parameter model's ones.
    ///
    /// ```
    /// let movieA = MovieModel()
    /// movieA.title = "A"
    /// let movieB = MovieModel()
    /// movieB.title = "B"
    /// (movieA.merge(with: movieB)).title // "A"
    ///
    /// ```
    ///
    /// - Parameters:
    ///     - with: a `MovieModel`to merge with the current one.
    ///
    /// - Returns: A new `MovieModel`.
    ///
    func merge(with: MovieModel) -> MovieModel {
        var newMovie = MovieModel()
        newMovie.id = id ?? with.id
        newMovie.title = title ?? with.title
        newMovie.year = year ?? with.year
        newMovie.genre = genre ?? with.genre
        newMovie.actors = actors ?? with.actors
        newMovie.director = director ?? with.director
        newMovie.plot = plot ?? with.plot
        newMovie.posterUrl = posterUrl ?? with.posterUrl
        return newMovie
    }
}
