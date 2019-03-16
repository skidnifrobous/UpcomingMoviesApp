//
//  Movie.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 14/03/19.
//  Copyright © 2019 Yuri Ramos. All rights reserved.
//

import Foundation
import Alamofire

class Movie: Codable {
    var id : Int?
    var title: String?
    var genreIds: [Int]?
    var genres: [Genre]?
    var posterPath: String?
    var overview: String?
    var releaseDate: String?
}

extension Movie {
    static func get(id:Int, onComplete: @escaping (_ result: APIResult<Movie>) -> Void) {
        let url = APIRouter.movie.urlPath + "/\(id)"
        var parameters : [String : Any] = [:]
        parameters["api_key"] = APIRouter.movie.apiKey
        parameters["language"] = "en-US"
        
        request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: [:])
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: [])
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let movie = try decoder.decode(Movie.self, from: data)
                        
                        let apiResult = APIResult.success(value: movie)
                        onComplete(apiResult)
                    } catch let error {
                        print("\(error.localizedDescription)")
                        let apiResult = APIResult<Movie>.failure(error)
                        onComplete(apiResult)
                    }
                case .failure(let error):
                    print("\(error.localizedDescription)")
                    let apiResult = APIResult<Movie>.failure(error)
                    onComplete(apiResult)
                }
        }
    }
    
    static func getUpcomming(page: Int, onComplete: @escaping (_ result: APIPaginatedResult<[Movie]>) -> Void) {
     
        let url = APIRouter.upcommingMovies.urlPath
        var parameters : [String : Any] = [:]
        parameters["page"] = page
        parameters["api_key"] = APIRouter.upcommingMovies.apiKey
        parameters["language"] = "en-US"
        
        request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: [:])
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json : [String:Any] = (value as? [String:Any]) ?? [:]
                    let page = json["page"] as? Int
                    let totalPages = json["total_pages"] as? Int
                    let results : Any = json["results"] ?? ""
                    do {
                        let data = try JSONSerialization.data(withJSONObject: results, options: [])
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let movies = try decoder.decode([Movie].self, from: data)
                        
                        let apiResult = APIPaginatedResult.success(value: movies,
                                                                   page: page ?? 0,
                                                                   totalPages: totalPages ?? 0)
                        onComplete(apiResult)
                    } catch let error {
                        print("\(error.localizedDescription)")
                        let apiResult = APIPaginatedResult<[Movie]>.failure(error)
                        onComplete(apiResult)
                    }
                case .failure(let error):
                    print("\(error.localizedDescription)")
                    let apiResult = APIPaginatedResult<[Movie]>.failure(error)
                    onComplete(apiResult)
                }
        }
    }
}
