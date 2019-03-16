//
//  APIResult.swift
//  MovieAppArchTouch
//
//  Created by Yuri Ramos on 14/03/19.
//  Copyright © 2019 Yuri Ramos. All rights reserved.
//

import Foundation

public enum APIResult<T> {
    case success(value:T)
    case failure(Error)
}

public enum APIPaginatedResult<T> {
    case success(value:T, page:Int, totalPages:Int)
    case failure(Error)
}
