//
//  GenreCache.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 14/03/19.
//  Copyright © 2019 Yuri Ramos. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didReceiveGenre = Notification.Name("didReceiveGenre")
}

class GenreCache {
    static var shared = GenreCache()
    var genres : [Genre] = []
    private init() {}
    
    func nameOfGenre(with id:Int) -> String? {
        if let genre = genres.filter({ $0.id == id }).first {
            return genre.name
        }
        return nil
    }
    
    func updateGenres() {
        Genre.getAll { (result) in
            switch result {
            case .success(let value):
                self.genres = value
                NotificationCenter.default.post(name: .didReceiveGenre, object: nil)
            case .failure(_):
                break
            }
        }
    }
    
    
}
