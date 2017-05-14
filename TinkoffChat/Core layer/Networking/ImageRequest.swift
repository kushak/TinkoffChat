//
//  ImageRequest.swift
//  TinkoffChat
//
//  Created by user on 14.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

protocol IRequest {
    var urlString: URL { get }
}

class ImageRequest: NSObject, IRequest {

    let baseUrl: String = "pixabay.com"
    let apiMethod: String = "/api/"
    let apiKey: String
    let limit: Int
    
    
    init(key: String, limit: Int) {
        self.apiKey = key
        self.limit = limit
    }
    
    var urlString: URL {
//        https://pixabay.com/api/?key=5364446-cc2a591dd0d58aacbad9344a2&q=yellow+flowers&image_type=photo&pretty=true&per_page=100
        
//        https://pixabay.com/api/?per_page=40&q=yellow+flowers&key=5364446-cc2a591dd0d58aacbad9344a2&image_type=photo&pretty=true
        let params = [
            "q": "yellow+flowers",
            "image_type": "photo",
            "pretty" : "true",
            "per_page" : String(limit),
            "key": apiKey
        ]
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        urlComponents.path = apiMethod
        urlComponents.queryItems = params.map { key, value in URLQueryItem(name: key, value: value) }
        
        return urlComponents.url!
    }
}
