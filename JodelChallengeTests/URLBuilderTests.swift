//
//  URLBuilderTests.swift
//  JodelChallengeTests
//
//  Created by Ghulam Mustafa on 30/06/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import XCTest
@testable import JodelChallenge

class URLBuilderTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func testFlickerInterestingnessApiURL() throws {
        
        let url =   URL(string:"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=11c40ef31e4961acf4f98c8ff4e945d7&format=json&nojsoncallback=1&per_page=20&page=1")
        let outputURL = URLBuilder.getFlickerInterestingnessAPIURL(for: 1)
        
        XCTAssertEqual(url, outputURL,"invalid API string")
    }
    
    func testPhotoURLAPI() throws {
        let url = URL(string:"https://farm66.static.flickr.com/578/23451156376_8983a8ebc7.jpg")
        let model = PhotoList(id: "23451156376", title: "Christmas Decorations", secret: "8983a8ebc7", server: "578", farm: 66)
        let outputURL = URLBuilder.photoURLAPI(photo: model)
        XCTAssertNotNil(outputURL,"invalid url")
        XCTAssertEqual(url, outputURL ?? URL(string:""),"invalid API string")
    }
}
