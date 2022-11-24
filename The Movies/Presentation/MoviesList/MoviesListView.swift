//
//  MoviesListView.swift
//  The Movies
//
//  Created by Fabian Hofmann on 01.11.22.
//

import SwiftUI

struct MoviesListView: View {
    
    var movies: [MovieModel] = []
    
    var body: some View {
        
        List(movies) { movie in
            if movie.id != nil {
                NavigationLink(destination: MovieDetailView(id: movie.id!)) {
                    MoviesListRowView(movie: movie)
                }
            }
        }
        .background(Color.teal)
        .scrollContentBackground(.hidden)
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var movies: [MovieModel] = (1...20)
        .map({ index in MovieModel(id: "\(index)", title: "Movie #\(index)", year: "\(2000 + Int.random(in: 1...20))", genre: "Action", actors: "Actor #\(index)", director: "Director", plot: "Plotty plot", posterUrl: "https://m.media-amazon.com/images/M/MV5BM2E3YTQwNmItZjA0NC00NDkzLTk5NjgtN2VlYTEzNGZlMjIzXkEyXkFqcGdeQXVyMzA3Njg4MzY@._V1_SX300.jpg") })
    
    static var previews: some View {
        MoviesListView(movies: movies)
    }
}
