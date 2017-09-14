//
//  ReturnRegexTests.swift
//  LLRegex
//
//  Created by Rock Young on 2017/6/5.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import XCTest
@testable import LLRegex

class ReturnRegexTests: RegexTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        s = "\n \r\n \r"
        regex = "\r".asRegex
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    override func testMatch() {
        
        let expected = regex.regularExpression.numberOfMatches(in: s, options: matchOptions.toAdapted(), range: s.nsRange)
        let result = regex.matches(in: s, options: matchOptions).all.count
        
        XCTAssertEqual(result, expected)
        XCTAssertEqual(result, 2)
        XCTAssertEqual(regex.matches(in: s, options: matchOptions).first?.matched, "\r")
    }
    
    override func testRaplace() {
        
    }
    
}
