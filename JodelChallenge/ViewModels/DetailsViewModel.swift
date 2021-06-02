//
//  DetailsViewModel.swift
//  JodelChallenge
//
//  Created by Ghulam Mustafa on 28/05/2021.
//  Copyright © 2021 Jodel. All rights reserved.
//

import UIKit

final class DetailsViewModel {
    // MARK: - Properties
    var details:PhotoDetailsModel
    
    var image: UIImage? {
        return details.image
    }
    
    var title: String? {
        return details.title
    }
    
    // MARK: - Methods
    init(details: PhotoDetailsModel) {
        self.details = details
    }
}
