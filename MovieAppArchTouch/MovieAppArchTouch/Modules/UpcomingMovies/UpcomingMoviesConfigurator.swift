//
//  UpcomingMoviesConfigurator.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 14/03/19.
//  Copyright (c) 2019 Yuri Ramos. All rights reserved.
//

import UIKit

protocol UpcomingMoviesConfigurable {
    func configure(viewController: UpcomingMoviesViewController)
}

class UpcomingMoviesConfigurator: UpcomingMoviesConfigurable {

    //MARK: UpcomingMoviesConfigurable
    func configure(viewController: UpcomingMoviesViewController) {
    
        let router = UpcomingMoviesRouter(viewController: viewController)
        
        let presenter = UpcomingMoviesPresenter(
            output: viewController,
            router: router
        )
        
        viewController.presenter = presenter

    }
}
