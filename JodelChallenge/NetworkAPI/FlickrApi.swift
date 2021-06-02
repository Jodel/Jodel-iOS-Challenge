//
//  FlickrApi.swift
//  JodelChallenge
//
//  Created by Ghulam Mustafa on 26/05/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import UIKit

final class FlickrApi {
    // MARK: - Properties
    static let shared = FlickrApi()
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    // MARK: - Methods
    private init() {}
    
    func fetchPhotosList(for page: Int, completion: @escaping (Result<PhotosModel, NetworkError>) -> Void) {
        
        guard let url = URLBuilder.getFlickerInterestingnessAPIURL(for: page) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let photosListData = try JSONDecoder().decode(FlickrFeedModel.self, from: data)
                completion(.success(photosListData.photos))
                
            } catch {
                completion(.failure(.invalidData))
            }
            
        }
        .resume()
        
    }
    
    
    func fetchPhoto(for url: URL, with indexPath: IndexPath, completion: @escaping (Result<(UIImage, IndexPath), Error>) -> Void) {
        
        if let cashedImage = cachedImages.object(forKey: url as NSURL) {
            completion(.success((cashedImage, indexPath)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completion(.failure(error!))
                return
            }
            
            self.cachedImages.setObject(image, forKey: url as NSURL)
            completion(.success((image, indexPath)))
        }
        .resume()
    }
    
    func clearCache() {
        cachedImages.removeAllObjects()
    }
    
}

// MARK: - Enum
enum NetworkError: String, Error {
    case invalidURL = "Invalid URL!"
    case invalidResponse = "Invalid Response!"
    case invalidData = "Invalid Data!"
    case unableToComplete = "Unable To Complete!"
}
