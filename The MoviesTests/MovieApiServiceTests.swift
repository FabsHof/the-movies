//
//  MovieApiServiceTests.swift
//  The MoviesTests
//
//  Created by Fabian Hofmann on 03.11.22.
//

import XCTest
@testable import The_Movies

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    // override resume and call the closure
    
    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    // data and error can be set to provide data or an error
    var data: Data?
    var error: Error?
    override func dataTask(
        with url: URL,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}

final class MovieApiServiceTests: XCTestCase {
    
    var mockSession: URLSessionMock?
    let smallJson = """
    {
        "Title": "The Lord of the Rings: The Return of the King",
        "Year": "2003",
        "imdbID": "tt0167260",
    }
    """

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockSession = URLSessionMock()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockSession = nil
    }
    
    func testSuccessfullyGetDataByValidId() throws {
        // Prepare
        mockSession!.data = smallJson.data(using: .utf8)
        let movieApiService = MovieApiService(session: mockSession!)
        var receivedError: Error?
        let expectation = self.expectation(description: "Get movie by id")
        var receivedData: Data?
        
        // Execute
        movieApiService.getById(imdbId: "", completionHandler: {data, response, error in
            receivedData = data
            receivedError = error
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 3)
        
        // Assert
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedData, smallJson.data(using: .utf8))
    }

}
