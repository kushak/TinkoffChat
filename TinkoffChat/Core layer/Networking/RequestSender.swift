//
//  RequestSender.swift
//  TinkoffChat
//
//  Created by user on 14.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

struct RequestConfig<T> {
    let request: IRequest
    let parser: Parser<T>
}

enum Result<T> {
    case Success(T)
    case Fail(String)
}

protocol IRequestSender {
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> Void)
}


class RequestSender: IRequestSender {
    
    let session = URLSession.shared
    
    
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> Void) {
        
        print("=== Request URL: \(config.request.urlString)")
        
        let urlRequest = URLRequest(url: config.request.urlString)
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(Result.Fail(error.localizedDescription))
                }
                guard let data = data,
                    let parseModel: T = config.parser.parse(data: data) else {
                        completionHandler(Result.Fail("recieved data can't be parsed"))
                        return
                }
                completionHandler(Result.Success(parseModel))
            }
        }
        task.resume()
    }
}
