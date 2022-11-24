//
//  MovieDetailView.swift
//  The Movies
//
//  Created by Fabian Hofmann on 01.11.22.
//

import SwiftUI
import Combine

struct MovieDetailView: View {
    
    @EnvironmentObject var moviesStore: MovieDataStore
    
    // TODO: Replace with @ObservableObject
    @State private var movie: MovieModel?
    // Does not work as well :(
//    @ObservedObject private var wrappedMovie: WrappedStruct<MovieModel>

    private var cancellable: AnyCancellable?
    
    let id: String
    
    // Allow model injections from the outside.
    init(id: String, movie: MovieModel? = nil) {
        self.id = id
        self.movie = movie
//        self._wrappedMovie = ObservedObject(wrappedValue: WrappedStruct(withItem: movie))
        
    }
    
    
    ///
    /// Triggers the `getById`-call of the store (and underlaying API) which fetches more detailed information of the movie, updates the store, resulting in an updating UI.
    /// **Note:** As mentioned in `README > Challenges`, the update is currently not reflected in UI.
    ///
    private func initMovie() {
        moviesStore.$movies
            .map({unfilteredMovies in
                return unfilteredMovies.first(where: {$0.id == id})
            })
            .filter{$0 != nil}
            .sink(receiveValue: {filteredMovie in
                movie = filteredMovie
            })
        moviesStore.getById(imdbId: id)
    }
    
    var body: some View {
        GeometryReader {metrics in
            VStack (alignment: .center) {
                AsyncImage(url: URL(string: movie?.posterUrl ?? "")) { phase in
                    
                    // The image is valid
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            // Limit the image to a maximum height of 40% of screen height.
                            .frame(height: metrics.size.height * 0.4)
                        
                        // An error appeared
                    } else if phase.error != nil {
                        Text("No image available")
                            .bold()
                        
                        // A placeholder for the loading state
                    } else {
                        ProgressView()
                            .font(.largeTitle)
                    }
                    
                }
                
                List {
                    VStack (alignment: .leading) {
                        Text(movie?.title ?? "-")
                            .font(.title3)
                        
                        HStack {
                            Text(movie?.year != nil ? String((movie?.year)!) : "-")
                            Spacer()
                                .frame(width: 20)
                            Text(movie?.genre ?? "-")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack (alignment: .leading)  {
                        Text("Director")
                            .font(.title2)
                        Text(movie?.director  ?? "-")
                            .foregroundColor(.secondary)
                    }
                    VStack (alignment: .leading)  {
                        Text("Actors")
                            .font(.title2)
                        Text(movie?.actors  ?? "-")
                            .foregroundColor(.secondary)
                    }
                    VStack (alignment: .leading)  {
                        Text("Plot")
                            .font(.title2)
                        Text(movie?.plot  ?? "-")
                            .foregroundColor(.secondary)
                    }
                }
                .background(Color.teal)
                .scrollContentBackground(.hidden)
            }
        }
        .background(Color.teal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {initMovie()}
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var movie: MovieModel = MovieModel(id: "id-1", title: "Movie #1", year: "2000", genre: "Action", actors: "Actor #1", director: "Director", plot: "Plotty plot", posterUrl: "https://m.media-amazon.com/images/M/MV5BM2E3YTQwNmItZjA0NC00NDkzLTk5NjgtN2VlYTEzNGZlMjIzXkEyXkFqcGdeQXVyMzA3Njg4MzY@._V1_SX300.jpg")
    
    static var previews: some View {
        MovieDetailView(id: movie.id!, movie: movie)
    }
}
