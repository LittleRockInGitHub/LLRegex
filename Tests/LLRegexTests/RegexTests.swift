//
//  RegexTests.swift
//  LLRegex
//
//  Created by Rock Young on 2017/6/4.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import XCTest
@testable import LLRegex

class RegexTests: XCTestCase {
    
    var s: String!
    var regex: Regex!
    var template: String!
    var matchOptions: Match.Options!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        s = "091-9320-32432432"
        regex = "\\d+".asRegex
        template = "($0)"
        matchOptions = []
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMatch() {
        
        let expected = regex.regularExpression.matches(in: s, options: matchOptions.toAdopated(), range: s.nsRange).flatMap { result in
            return result.range.toRange(in: s).map({ s.substring(with: $0) })
        }
        
        let result = regex.matches(in: s, options: matchOptions).map { $0.matched }
        
        XCTAssertEqual(result, expected)
        
    }
    
    func testRaplace() {
        
        let expected = regex.regularExpression.stringByReplacingMatches(in: s, options: matchOptions.toAdopated(), range: s.nsRange, withTemplate: template)
        
        let result = regex.replacingAllMatches(in: s, options: matchOptions, replacement: .replaceWithTemplate(template))
        
        XCTAssertEqual(result, expected)
        
    }
}
