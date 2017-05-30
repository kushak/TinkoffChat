//
//  FactorialTests.swift
//  TinkoffChat
//
//  Created by user on 26.05.17.
//  Copyright © 2017 Oleg Shipulin. All rights reserved.
//

import XCTest

@testable import TinkoffChat

class FactorialTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFactorial() {
        let factorial = Factorial()
        let result = factorial.calculateFac(number: 3)
        
        XCTAssertEqual(result, 1*2*3)
    }
    
    func testFactorialForNil() {
        let factorial = Factorial()
        let result = factorial.calculateFac(number: 0)
        
        XCTAssertEqual(result, 1)
    }
    
}
