//
//  MovieDetailPresenter.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 15/03/19.
//  Copyright (c) 2019 Yuri Ramos. All rights reserved.
//

import Foundation

protocol MovieDetailPresenterInput: BasePresenterInput {
    
    var router: MovieDetailRoutable { get }
    
    func getMovie(movieId:Int)
    
}

protocol MovieDetailPresenterOutput: BasePresenterOutput {
    func showMovie(movie:Movie)
    func toggleHUD(_ on:Bool)
}

class MovieDetailPresenter {
    
    //MARK: Injections
    private weak var output: MovieDetailPresenterOutput?
    var router: MovieDetailRoutable
    
    //MARK: LifeCycle 
    init(output: MovieDetailPresenterOutput,
         router: MovieDetailRoutable) {
        
        self.output = output
        self.router = router
    }
    
}

// MARK: - MovieDetailPresenterInput
extension MovieDetailPresenter: MovieDetailPresenterInput {
    
    func viewDidLoad() {
        
    }
    
    func getMovie(movieId: Int) {
        self.output?.toggleHUD(true)
        Movie.get(id: movieId) { (result) in
            switch result {
            case .success(let value):
                self.output?.showMovie(movie: value)
            case .failure(_):
                break
            }
            self.output?.toggleHUD(false)
        }
    }
   
}

