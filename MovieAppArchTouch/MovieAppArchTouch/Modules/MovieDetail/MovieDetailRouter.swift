//
//  MovieDetailRouter.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 15/03/19.
//  Copyright (c) 2019 Yuri Ramos. All rights reserved.
//

import UIKit

protocol MovieDetailRoutable: ViewRoutable {
    
}

class MovieDetailRouter {
    
    // MARK: Injections
    weak var viewController: UIViewController?
    
    // MARK: LifeCycle
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
}

// MARK: - MovieDetailRoutable
extension MovieDetailRouter: MovieDetailRoutable {
    
}
