//
//  MovieModelSearchResponseModelTests.swift
//  The MoviesTests
//
//  Created by Fabian Hofmann on 03.11.22.
//

import XCTest
@testable import The_Movies

final class MovieModelSearchResponseModelTests: XCTestCase {

    let completeJson = """
    {
        "totalResults": "1000",
        "Search": []
    }
    """
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSuccessfullyCreatingModelFromJSON () throws {
        // Prepare
        let decoder = JSONDecoder()
        let jsonData = completeJson.data(using: .utf8)
        
        // Perform
        var movieResultsModel: MovieModelSearchResponseModel?
        
        // Assert
        XCTAssertNoThrow(movieResultsModel = try decoder.decode(MovieModelSearchResponseModel.self, from: jsonData!))
        XCTAssert(movieResultsModel?.totalResults == "1000")
    }

}
