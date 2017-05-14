//
//  ImageModel.swift
//  TinkoffChat
//
//  Created by user on 14.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

protocol ImageModelProtocol {
    func fetchImage(completionHandler: @escaping  () -> ())
}

class ImageModel: NSObject {
    
    let imageService: ImageService
    var imageShow = [ImageApiModel]()
    
    init(imageService: ImageService) {
        self.imageService = imageService
    }
    
    func fetchImage(completionHandler: @escaping () -> ()) {
        
        imageService.loadImage(completionHandler: { (images, error) in
            if let images = images {
                self.imageShow = images
                completionHandler()
            }
        })
    }
}
