//
//  FlickrApiTests.swift
//  JodelChallengeTests
//
//  Created by Ghulam Mustafa on 30/05/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import XCTest
@testable import JodelChallenge

class FlickrApiTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testfetchPhotosListSuccess() throws {
        
        let expectation = self.expectation(description: "Photo list is fetched")
        
        FlickrApi.shared.fetchPhotosList(for: 1, completion: { result in
            switch result {
            case .success(let photoList):
                XCTAssertNotNil(photoList, "Invalid photo list")
            case .failure(let error ):
                XCTFail("Expected to be a success but got a failure with \(error)")
            }
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: TimeInterval(10), handler: nil)
    }
    
    func testFetchPhotoSuccess() throws {
        let expectation = self.expectation(description: "Photo is fetched")
        let url = URL(string: "https://farm66.static.flickr.com/65535/51215625131_79bdf32dea.jpg")!
        let inputIndexPath = IndexPath(row: 1, section: 0)
        FlickrApi.shared.fetchPhoto(for: url, with: inputIndexPath, completion: { result in
            switch result {
            case .success((let image, let indexPath)):
                XCTAssertNotNil(image,"success")
                XCTAssertEqual(inputIndexPath, indexPath,"invalid index path")
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: TimeInterval(10), handler: nil)
    }
    
}
