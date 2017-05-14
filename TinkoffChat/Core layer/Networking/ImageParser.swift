//
//  ImageParser.swift
//  TinkoffChat
//
//  Created by user on 14.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class Parser<T> {
    func parse(data: Data) -> T? { return nil }
}

struct ImageApiModel {
    let url: String
}

class ImageParser: Parser<[ImageApiModel]> {

    override func parse(data: Data) -> [ImageApiModel]? {
        
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return nil }
            
            guard let images = json["hits"] as? [[String: Any]] else {return nil}
            
            print(images)
            
            var apiImages = [ImageApiModel]()
            
            for image in images {
                guard let imageUrl = image["webformatURL"] as? String
                    else {continue}
                apiImages.append(ImageApiModel(url: imageUrl))
            }
            return apiImages
            
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
    }
}
