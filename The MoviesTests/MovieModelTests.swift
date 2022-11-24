//
//  MovieModelTests.swift
//  The MoviesTests
//
//  Created by Fabian Hofmann on 03.11.22.
//

import XCTest
@testable import The_Movies

final class MovieModelTests: XCTestCase {
    
    let completeJson = """
    {
        "Title": "The Lord of the Rings: The Return of the King",
        "Year": "2003",
        "Rated": "PG-13",
        "Released": "17 Dec 2003",
        "Runtime": "201 min",
        "Genre": "Action, Adventure, Drama",
        "Director": "Peter Jackson",
        "Writer": "J.R.R. Tolkien, Fran Walsh, Philippa Boyens",
        "Actors": "Elijah Wood, Viggo Mortensen, Ian McKellen",
        "Plot": "Gandalf and Aragorn lead the World of Men against Sauron's army to draw his gaze from Frodo and Sam as they approach Mount Doom with the One Ring.",
        "Language": "English, Quenya, Old English, Sindarin",
        "Country": "New Zealand, United States",
        "Awards": "Won 11 Oscars. 209 wins & 124 nominations total",
        "Poster": "https://m.media-amazon.com/images/M/MV5BNzA5ZDNlZWMtM2NhNS00NDJjLTk4NDItYTRmY2EwMWZlMTY3XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg",
        "Ratings": [
            {
                "Source": "Internet Movie Database",
                "Value": "9.0/10"
            },
            {
                "Source": "Rotten Tomatoes",
                "Value": "93%"
            },
            {
                "Source": "Metacritic",
                "Value": "94/100"
            }
        ],
        "Metascore": "94",
        "imdbRating": "9.0",
        "imdbVotes": "1,830,463",
        "imdbID": "tt0167260",
        "Type": "movie",
        "DVD": "25 May 2004",
        "BoxOffice": "$378,251,207",
        "Production": "N/A",
        "Website": "N/A",
        "Response": "True"
    }
    """

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSuccessfullyMergeTwoModels() {
        // Prepare
        var movie1 = MovieModel()
        var movie2 = MovieModel()
        
        movie1.title = "A"
        movie2.title = "B"
        movie2.id = "id-b"
        
        // Perform
        movie1 = movie1.merge(with: movie2)
        
        // Assert
        XCTAssert(movie1.title! == "A")
        XCTAssert(movie2.title! == "B")
        XCTAssert(movie1.id! == "id-b")
    }
    
    func testSuccessfullyCreatingModelFromJSON () throws {
        // Prepare
        let decoder = JSONDecoder()
        let jsonData = completeJson.data(using: .utf8)
        let expectedTitle = "The Lord of the Rings: The Return of the King"
        
        // Perform
        var movieModel: MovieModel?
        
        // Assert
        XCTAssertNoThrow(movieModel = try decoder.decode(MovieModel.self, from: jsonData!))
        XCTAssert(movieModel?.title == expectedTitle)
    }

}
