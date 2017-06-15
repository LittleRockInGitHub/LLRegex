//
//  EmptyStringRegexTests.swift
//  LLRegex
//
//  Created by Rock Young on 2017/6/5.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import XCTest

class EmptyStringRegexTests: RegexTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        s = ""
        regex = "()".asRegex
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
