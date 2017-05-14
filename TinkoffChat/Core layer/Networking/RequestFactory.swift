//
//  RequestFactory.swift
//  TinkoffChat
//
//  Created by user on 14.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

struct RequstFactory {
    
    struct PhotosRequests {
        
        static func photosConfig() -> RequestConfig<[ImageApiModel]> {
            let apiKey = "5364446-cc2a591dd0d58aacbad9344a2"
            return RequestConfig<[ImageApiModel]>(request: ImageRequest(key: apiKey, limit: 40), parser: ImageParser())
        }
        
    }
    
    
}
