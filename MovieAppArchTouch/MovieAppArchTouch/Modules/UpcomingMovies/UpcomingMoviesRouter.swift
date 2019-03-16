//
//  UpcomingMoviesRouter.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 14/03/19.
//  Copyright (c) 2019 Yuri Ramos. All rights reserved.
//

import UIKit

protocol UpcomingMoviesRoutable: ViewRoutable {
    func goToMovieDetail(movieId: Int)
}

class UpcomingMoviesRouter {
    
    // MARK: Injections
    weak var viewController: UIViewController?
    
    // MARK: LifeCycle
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
}

// MARK: - UpcomingMoviesRoutable
extension UpcomingMoviesRouter: UpcomingMoviesRoutable {
    func goToMovieDetail(movieId: Int) {
        let movieDetailViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "movieDetail") as! MovieDetailViewController
        movieDetailViewController.movieId = movieId
        viewController?.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
