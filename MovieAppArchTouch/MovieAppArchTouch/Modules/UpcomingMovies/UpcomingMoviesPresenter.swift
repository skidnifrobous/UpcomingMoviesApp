//
//  UpcomingMoviesPresenter.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 14/03/19.
//  Copyright (c) 2019 Yuri Ramos. All rights reserved.
//

import Foundation

protocol UpcomingMoviesPresenterInput: BasePresenterInput {
    
    var router: UpcomingMoviesRoutable { get }
    
    func getUpcommingMovies(search: String?)
    func getNextPage(search: String?)
    func selectedMovie(id: Int?)
    
}

protocol UpcomingMoviesPresenterOutput: BasePresenterOutput {
    func showMovies(movies: [Movie])
    func showMoreMovies(movies: [Movie])
    func toggleLoading(_ on: Bool)
}

class UpcomingMoviesPresenter {
    
    //MARK: Injections
    private weak var output: UpcomingMoviesPresenterOutput?
    var router: UpcomingMoviesRoutable
    
    //MARK: Variables
    var movieList : [Movie] = []
    var page = 1
    var totalPages = 0
    
    //MARK: LifeCycle 
    init(output: UpcomingMoviesPresenterOutput,
         router: UpcomingMoviesRoutable) {
        
        self.output = output
        self.router = router
    }
    
}

// MARK: - UpcomingMoviesPresenterInput
extension UpcomingMoviesPresenter: UpcomingMoviesPresenterInput {
    
    func viewDidLoad() {
        self.getUpcommingMovies(search: nil)
    }
    
    func getUpcommingMovies(search: String?) {
        self.page = 1
        self.output?.toggleLoading(true)
        Movie.getUpcomming(page: self.page) { (apiResult) in
            switch apiResult {
            case .success(let result):
                self.totalPages = result.totalPages
                var qmovies = result.value
                if let query = search, !query.isEmpty {
                    qmovies = qmovies.filter{
                        ($0.title ?? "").lowercased().contains(query.lowercased())
                    }
                }
                self.movieList.removeAll()
                self.movieList.append(contentsOf: qmovies)
                self.output?.showMovies(movies: qmovies)
            case .failure(_):
                break
            }
            self.output?.toggleLoading(false)
        }
    }
    
    func getNextPage(search: String?) {
        self.page += 1
        if self.page >= self.totalPages {
            return
        }
        Movie.getUpcomming(page: self.page) { (apiResult) in
            switch apiResult {
            case .success(let result):
                var qmovies = result.value
                if let query = search, !query.isEmpty {
                    qmovies = qmovies.filter{
                        ($0.title ?? "").lowercased().contains(query.lowercased())
                    }
                }
                self.movieList.removeAll()
                self.movieList.append(contentsOf: qmovies)
                self.output?.showMoreMovies(movies: qmovies)
            case .failure(_):
                break
            }
        }
    }
    
    func selectedMovie(id: Int?) {
        guard let movieId = id else {
            print("Movie does not have Id.")
            return
        }
        router.goToMovieDetail(movieId: movieId)
    }
}

