//
//  DetailsViewController.swift
//  JodelChallenge
//
//  Created by Ghulam Mustafa on 28/05/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var imgView: UIImageView!
    var detailViewModel: DetailsViewModel?
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailsView()
    }
    
    fileprivate func setupDetailsView() {
        navigationItem.largeTitleDisplayMode = .never
        if let image = detailViewModel?.image, let title = detailViewModel?.title {
            self.title = title
            imgView.image = image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
