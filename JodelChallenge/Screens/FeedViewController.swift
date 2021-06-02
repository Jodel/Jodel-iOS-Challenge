//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

final class FeedViewController : UICollectionViewController {
    // MARK: - Properties
    private let feedViewModel = FeedViewModel()
    private let reuseIdentifier = "FeedCell"
    private let itemsPerRow: CGFloat = 1
    private let sectionInsets = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Flickr Feed"
        setupFeedViewModelHandler()
        setupRefreshControl()
        showLoadingView()
        feedViewModel.fetchPhotoList()
    }
    
    fileprivate func setupFeedViewModelHandler() {
        feedViewModel.updateFeedView = { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            self.endRefreshing()
        }
        
        feedViewModel.didReceiveError = { [weak self] (error) in
            guard let self = self else { return }
            self.presentAlertOnMainThread(title: error.rawValue, message: error.localizedDescription)
            self.endRefreshing()
        }
    }
    
    fileprivate func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .label
        refreshControl.addTarget(self, action: #selector(reloadFeed), for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
    }
    
    fileprivate func endRefreshing() {
        DispatchQueue.main.async {
            if let refreshControl = self.collectionView.refreshControl {
                if !refreshControl.isRefreshing {
                    self.dismissLoadingView()
                }
                refreshControl.endRefreshing()
            }
        }
        
    }
    
    @objc fileprivate func reloadFeed(refreshControl: UIRefreshControl) {
        feedViewModel.clearFeed()
        feedViewModel.fetchPhotoList()
    }
}

// MARK: - UICollectionViewDataSource
extension FeedViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedViewModel.photoURLs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        if let image = UIImage(systemName: "photo") {
            cell.configure(for: image, with: "")
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if feedViewModel.photoURLs.isEmpty { return }
        let url = feedViewModel.photoURLs[indexPath.row]
        
        feedViewModel.fetchPhoto(for: url, with: indexPath) { (image, title, index) in
            DispatchQueue.main.async {
                if let currentCell = collectionView.cellForItem(at: index) as? FeedCell {
                    currentCell.configure(for: image, with: title)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FeedViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailsVC = storyboard?.instantiateViewController(identifier: "Detail") as? DetailsViewController {
            let cell = collectionView.cellForItem(at: indexPath) as! FeedCell
            
            let detailModel = PhotoDetailsModel(image: cell.image, title: cell.title)
            detailsVC.detailViewModel = DetailsViewModel(details: detailModel)
            
            detailsVC.modalTransitionStyle = .coverVertical
            
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionInsets = UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 2.0)
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = (availableWidth / 1.5) + 40
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: - UIScrollViewDelegate
extension FeedViewController {
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let refreshControl = self.collectionView.refreshControl, !refreshControl.isRefreshing {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            if offsetY > contentHeight - height-100 {
                guard feedViewModel.hasMorePhotos else { return }
                showLoadingView()
                feedViewModel.fetchPhotoList()
            }
        }
    }
    
}




