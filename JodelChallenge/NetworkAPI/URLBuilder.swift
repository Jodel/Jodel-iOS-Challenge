//
//  URLBuilder.swift
//  JodelChallenge
//
//  Created by Ghulam Mustafa on 26/05/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

final class URLBuilder {
    
    private static let flickrAPIKey = "11c40ef31e4961acf4f98c8ff4e945d7"
    private static let baseURL = "https://api.flickr.com/services/rest/"
    private static let resultsPerPage = 20
    
    class func getFlickerInterestingnessAPIURL(for page: Int) -> URL? {
        let endPointURL = "\(baseURL)?method=flickr.interestingness.getList&api_key=\(flickrAPIKey)&format=json&nojsoncallback=1&per_page=\(resultsPerPage)&page=\(page)"
        
        guard let endPointURL = URL(string: endPointURL) else { return nil }
        
        return endPointURL
    }
    
    class func photoURLAPI(photo: PhotoList) -> URL? {
        let photoURL = "https://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        
        guard let photoURL = URL(string: photoURL) else { return nil }
        
        return photoURL
    }
    
}
