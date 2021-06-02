//
//  FeedViewModel.swift
//  JodelChallenge
//
//  Created by Ghulam Mustafa on 25/05/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import UIKit

final class FeedViewModel {
    // MARK: - Properties
    var updateFeedView: (() -> Void)?
    var didReceiveError: ((NetworkError) -> Void)?
    
    var photoURLs = [URL]()
    var photoTitles = [String]()
    var page = 0
    var hasMorePhotos = true
    
    // MARK: - Methods
    func fetchPhotoList() {
        FlickrApi.shared.fetchPhotosList(for: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            
            case .success(let photoModel):
                self.page += 1
                for item in photoModel.photo {
                    if let url = URLBuilder.photoURLAPI(photo: item) {
                        self.photoURLs.append(url)
                        self.photoTitles.append(item.title)
                    }
                }
                
                if self.page >= photoModel.pages { self.hasMorePhotos = false }
                self.updateFeedView?()
                
            case .failure(let error):
                switch error {
                
                case .invalidURL:
                    self.didReceiveError?(.invalidURL)
                    
                case .invalidResponse:
                    self.didReceiveError?(.invalidResponse)
                    
                case .invalidData:
                    self.didReceiveError?(.invalidData)
                    
                case .unableToComplete:
                    self.didReceiveError?(.unableToComplete)
                }
            }
        }
    }
    
    func fetchPhoto(for url: URL, with indexPath: IndexPath , completion: @escaping (UIImage, String, IndexPath) -> ()) {
        FlickrApi.shared.fetchPhoto(for: url, with: indexPath) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            
            case .success((let image, let indexPath)):
                let title = self.photoTitles[indexPath.row]
                completion(image, title, indexPath)
                
            case .failure(_ ): break
            //print("Photo not found")
            }
        }
    }
    
    func clearFeed() {
        page = 0
        hasMorePhotos = true
        photoURLs.removeAll()
        photoTitles.removeAll()
        FlickrApi.shared.clearCache()
    }
    
}


