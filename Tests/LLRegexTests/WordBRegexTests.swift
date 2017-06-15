//
//  WordBRegexTests.swift
//  LLRegex
//
//  Created by Rock Young on 2017/6/4.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import XCTest

class WordBRegexTests: RegexTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        regex = "\\B".asRegex
        s = "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃zelda\n Link™"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
