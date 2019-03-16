//
//  Genre.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 14/03/19.
//  Copyright © 2019 Yuri Ramos. All rights reserved.
//

import Foundation
import Alamofire

class Genre: Codable {
    var id : Int?
    var name : String?
}

extension Genre {
    static func getAll(onComplete: @escaping (_ result: APIResult<[Genre]>) -> Void) {
        let url = APIRouter.genreList.urlPath
        var parameters : [String : Any] = [:]
        parameters["api_key"] = APIRouter.genreList.apiKey
        parameters["language"] = "en-US"
        
        request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: [:])            
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json : [String:Any] = (value as? [String:Any]) ?? [:]
                    let query : Any = json["genres"] ?? ""
                    do {
                        let data = try JSONSerialization.data(withJSONObject: query, options: [])
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let genres = try decoder.decode([Genre].self, from: data)
                        let apiResult = APIResult.success(value: genres)
                        onComplete(apiResult)
                    } catch let error {
                        print("\(error.localizedDescription)")
                        let apiResult = APIResult<[Genre]>.failure(error)
                        onComplete(apiResult)
                    }
                case .failure(let error):
                    print("\(error.localizedDescription)")
                    let apiResult = APIResult<[Genre]>.failure(error)
                    onComplete(apiResult)
                }
        }
    }
}
