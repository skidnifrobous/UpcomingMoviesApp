//
//  APIRouter.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 14/03/19.
//  Copyright © 2019 Yuri Ramos. All rights reserved.
//

import Foundation

enum APIRouter: String {
    case movie = "movie"
    case upcommingMovies = "movie/upcoming"
    case genreList = "genre/movie/list"
    
    private var baseUrl : String {
        return "https://api.themoviedb.org"
    }
    
    private var apiVersion : String {
        return "3"
    }
    
    var urlPath : String {
        return "\(baseUrl)/\(apiVersion)/\(self.rawValue)"
    }
    
    var apiKey : String {
        return "1f54bd990f1cdfb230adb312546d765d"
    }
}
