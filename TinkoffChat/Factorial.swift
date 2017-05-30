//
//  Factorial.swift
//  TinkoffChat
//
//  Created by user on 26.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import UIKit

class Factorial: NSObject {
    
    public func calculateFac(number: UInt) -> UInt {
        
        guard number != 0 else {
            return 1
        }
        
        var result: UInt = 1
        
        for i in 1...number {
            result *= i
        }
        return result
    }
}
