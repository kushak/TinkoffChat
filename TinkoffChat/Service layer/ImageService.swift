//
//  ImageService.swift
//  TinkoffChat
//
//  Created by user on 14.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

protocol ImageServiceProtocol {
    func loadImage(completionHandler: @escaping ([ImageApiModel]?, String?) -> Void)
}

class ImageService: NSObject {

    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadImage(completionHandler: @escaping ([ImageApiModel]?, String?) -> Void) {
        
        let requestConfig: RequestConfig<[ImageApiModel]> = RequstFactory.PhotosRequests.photosConfig()
        requestSender.send(config: requestConfig) { (result: Result<[ImageApiModel]>) in
            switch result {
            case .Success(let images):
                print(images.count)
                completionHandler(images, nil)
            case .Fail(let error):
                completionHandler(nil, error)
            }
        }
    }
    
}
