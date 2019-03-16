//
//  MovieDetailViewController.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 15/03/19.
//  Copyright (c) 2019 Yuri Ramos. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movieId : Int?
    var hud = HUD()
    
    // MARK: Outlets
    @IBOutlet weak var poster : UIImageView!
    @IBOutlet weak var backGround : UIImageView!
    @IBOutlet weak var movieTitle : UILabel!
    @IBOutlet weak var genre : UILabel!
    @IBOutlet weak var releaseDate : UILabel!
    @IBOutlet weak var overview : UILabel!
    
    // MARK: Injections
    var presenter: MovieDetailPresenterInput!
    var configurator: MovieDetailConfigurable!

    // MARK: View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Movie"
        configurator = MovieDetailConfigurator()
        configurator.configure(viewController: self)
        presenter.viewDidLoad()
        if let id = movieId {
            presenter.getMovie(movieId: id)
        }
    }

}

// MARK: - MovieDetailPresenterOutput
extension MovieDetailViewController: MovieDetailPresenterOutput {
    func showMovie(movie: Movie) {
        if let posterPath = movie.posterPath {
            let url = URL(string: APIImageUrl.w342.imageUrl(imageName: posterPath))!
            backGround.kf.setImage(with: url)
            poster.kf.setImage(with: url)
        }
        
        movieTitle.text = movie.title
        let genres = movie.genres?.map{ $0.name ?? ""}
                                  .joined(separator: ", ")
        genre.text = genres
        releaseDate.text = movie.releaseDate
        overview.text = movie.overview
        
        self.view.layoutSubviews()
    }
    
    func toggleHUD(_ on: Bool) {
        if on {
            hud.showIn(self.view, backGroundOpaque: true)
        } else {
            hud.hide(animated: true)
        }
    }
}
