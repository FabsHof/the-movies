//
//  MoviewsView.swift
//  The Movies
//
//  Created by Fabian Hofmann on 01.11.22.
//

import SwiftUI

struct MoviesView: View {
    
    @EnvironmentObject var moviesStore: MovieDataStore
    
    @State private var searchString: String = ""
    @State private var isInitial: Bool = true;
    @State private var debounceTimer: Timer?
    
    /// Minimum search string length to trigger a search.
    private var searchThreshold: Int = 3
    /// Debounce time after each new text field input after which a new search is triggered.
    private var debounceTimeS: Double = 0.5 // seconds
    
    ///
    /// Triggers a store reset on search results and empties out the text field.
    ///
    private func resetSearch() -> Void {
        searchString = ""
        moviesStore.reset()
    }
    
    ///
    /// Internally debounces the search-process, after a user input is made. See `searchThreshold` and `debounceTimeS` for more information.
    ///
    private func triggerSearch(_ searchStr: String) -> Void {
        
        isInitial = false
        
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceTimeS, repeats: false) {_ in
            if (searchStr.count < searchThreshold) {
                moviesStore.reset()
            } else {
                moviesStore.getAll(searchString: searchStr)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            
            VStack (alignment: .center) {
                HStack (spacing: 5) {
                    Spacer()
                    Image(systemName: "popcorn.fill").foregroundColor(.white)
                    Text("The Movies")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                
                HStack {
                    
                    TextField("Movie title", text: $searchString)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onChange(of: searchString, perform: triggerSearch)
                        .padding(5)
                }
                .background(Color.white)
                .cornerRadius(5)
                .padding(5)
                
                // If an error ocurred, display a message and provide a reset-button.
                if (moviesStore.error != nil) {
                    VStack {
                        Image(systemName: "bolt.fill")
                            .imageScale(.medium)
                            .foregroundColor(.red)
                        Text("An error occured!")
                            .font(.callout)
                            .bold()
                            .foregroundColor(.red)
                        Spacer()
                            .frame(height: 20)
                        Text(moviesStore.error!.localizedDescription)
                            .font(.callout)
                            .foregroundColor(.red)
                        Button(action: {resetSearch()}) {
                            HStack {
                                Text("Reset")
                                Image(systemName: "gobackward")
                            }
                            .foregroundColor(.white)
                        }
                            .padding([.top])
                    }
                    .padding([.top])
                    Spacer()
                    
                // During the search-process, show a loading spinner
                } else if (moviesStore.isLoading) {
                    HStack {
                        ProgressView()
                            .padding([.top, .bottom])
                        Text("Searching for \"\(searchString)\"...")
                    }
                    Spacer()
                    
                // For the initial case or the search string is too short.
                } else if (isInitial || searchString.count < searchThreshold) {
                    Text("\(isInitial ? "Start" : "Continue") typing to search for movies!")
                        .font(.callout)
                        .padding([.top, .bottom])
                    Spacer()
                
                // If we have valid results, show a list of elements
                } else {
                    VStack {
                        Text("\(moviesStore.totalResults) results for \"\(searchString)\"")
                        MoviesListView(movies: moviesStore.movies)
                    }
                    .accessibilityIdentifier("resultStack")
                    .background(Color.teal)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.teal)
        }
    }
}

struct MoviewsView_Previews: PreviewProvider {
    static let moviesStore: MovieDataStore = MovieDataStore()
    
    static var previews: some View {
        MoviesView()
            .environmentObject(moviesStore)
    }
}
