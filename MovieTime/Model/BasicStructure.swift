//
//  BasicStructure.swift
//  MovieTime
//
//  Created by crdr on 19/03/19.
//  Copyright © 2019 AAGroup. All rights reserved.
//

import Foundation

struct MoviewDetails {
    static var movieDetails = [String: AnyObject]()
    static var movie = [[String: AnyObject]]()
}

struct API {
    static var apiKey = "2758fdf8c2125bb54354ddc86d04c4a2"
    static var api = "popular"
    static var isGetResponse: Bool = true
    static var currentPage : Int = 1
}
