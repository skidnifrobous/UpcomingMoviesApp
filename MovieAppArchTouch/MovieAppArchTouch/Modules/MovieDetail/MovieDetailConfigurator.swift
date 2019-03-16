//
//  MovieDetailConfigurator.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 15/03/19.
//  Copyright (c) 2019 Yuri Ramos. All rights reserved.
//

import UIKit

protocol MovieDetailConfigurable {
    func configure(viewController: MovieDetailViewController)
}

class MovieDetailConfigurator: MovieDetailConfigurable {

    //MARK: MovieDetailConfigurable
    func configure(viewController: MovieDetailViewController) {
    
        let router = MovieDetailRouter(viewController: viewController)
        
        let presenter = MovieDetailPresenter(
            output: viewController,
            router: router
        )
        
        viewController.presenter = presenter

    }
}
