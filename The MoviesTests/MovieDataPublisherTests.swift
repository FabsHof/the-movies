//
//  MovieDataPublisherTests.swift
//  The MoviesTests
//
//  Created by Fabian Hofmann on 03.11.22.
//

import XCTest
@testable import The_Movies

class MovieApiServiceMock: MovieApiServiceProtocol {
    var session: URLSession
    var error: Error?
    let jsonMovie = """
    {
        "Title": "The Lord of the Rings: The Return of the King",
        "Year": "2003",
        "imdbID": "tt0167260",
    }
    """
    let totalResultsJson = """
    {
        "Search": [
            {
                "Title": "The Lord of the Rings: The Return of the King",
                "Year": "2003",
                "imdbID": "tt0167260",
            }
        ],
        "totalResults": "11976",
        "Response": "True"
    }
    
    """
    
    init(session: URLSession = URLSessionMock()) {
        self.session = session
    }
    
    func getById(imdbId: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completionHandler(jsonMovie.data(using: .utf8), nil, error)
    }
    
    func getAll(searchString: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completionHandler(totalResultsJson.data(using: .utf8), nil, error)
    }
    
    
}


final class MovieDataPublisherTests: XCTestCase {

    var movieApiService: MovieApiServiceMock?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSuccessfullyGetMovieByValidId() throws {
        // Prepare
        movieApiService = MovieApiServiceMock()
        let dataPublisher: MovieDataPublisherProtocol = MovieDataPublisher(movieApiService: movieApiService!)
        var error: Error?
        let expectation = self.expectation(description: "Get movie by id")
        var movie: MovieModel?
        let expectedTitle: String = "The Lord of the Rings: The Return of the King"
        
        // Execute
        dataPublisher.getById(imdbId: "tt12345")
            .first()
            .sink(receiveCompletion: {_ in }, receiveValue: {value in
                movie = value
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 2)
        
        // Assert
        XCTAssertNil(error)
        XCTAssertEqual(movie?.title, expectedTitle)
    }
    
    func testSuccessfullyGetAllMovies() throws {
        // Prepare
        movieApiService = MovieApiServiceMock()
        let dataPublisher: MovieDataPublisherProtocol = MovieDataPublisher(movieApiService: movieApiService!)
        var error: Error?
        let expectation = self.expectation(description: "Get movie by id")
        var movies: [MovieModel] = []
        let expectedTitle: String = "The Lord of the Rings: The Return of the King"
        let expectedCount: Int = 1
        
        // Execute
        dataPublisher.getAll(searchString: "tt12345")
            .first()
            .sink(receiveCompletion: {_ in }, receiveValue: {value in
                movies = value.movies
                expectation.fulfill()
            })
        
        waitForExpectations(timeout: 2)
        
        // Assert
        XCTAssertNil(error)
        XCTAssertEqual(movies.count, expectedCount)
        XCTAssertEqual(movies[0].title, expectedTitle)
    }

    

}
