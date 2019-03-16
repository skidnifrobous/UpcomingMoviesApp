//
//  APIImageUrl.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 14/03/19.
//  Copyright © 2019 Yuri Ramos. All rights reserved.
//

import Foundation

enum APIImageUrl: String {
    case w92
    case w154
    case w185
    case w342
    case w500
    case w780
    case original
    
    private var baseUrl : String {
        return "https://image.tmdb.org/t/p/"
    }
    
    func imageUrl(imageName:String) -> String {
        return "\(baseUrl)\(self.rawValue)\(imageName)"
    }
}
