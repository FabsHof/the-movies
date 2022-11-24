//
//  MoviesListRowView.swift
//  The Movies
//
//  Created by Fabian Hofmann on 01.11.22.
//

import SwiftUI

struct MoviesListRowView: View {
    
    var movie: MovieModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(movie.title!)
                .font(.title3)
            Text(movie.year != nil ? String(movie.year!) : "-")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct MoviesListRowView_Previews: PreviewProvider {
    static var movie: MovieModel = MovieModel(id: "id-1", title: "Movie #1", year: "2000", genre: "Action", actors: "Actor #1", director: "Director", plot: "Plotty plot", posterUrl: "https://m.media-amazon.com/images/M/MV5BM2E3YTQwNmItZjA0NC00NDkzLTk5NjgtN2VlYTEzNGZlMjIzXkEyXkFqcGdeQXVyMzA3Njg4MzY@._V1_SX300.jpg")
    static var previews: some View {
        MoviesListRowView(movie: movie)
    }
}
