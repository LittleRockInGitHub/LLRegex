//
//  NamedCaptureGroupsTests.swift
//  LLRegex
//
//  Created by Rock Yang on 2017/6/21.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import XCTest
@testable import LLRegex

class NamedCaptureGroupsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExtraction() {
    
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "\\d", expectedGroupsCount: 1), [:])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "()", expectedGroupsCount: 2), [:])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?<name>abc)", expectedGroupsCount: 2), ["name": 1])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?<name>abc)-(?<number1>\\d+)", expectedGroupsCount: 3), ["name": 1, "number1": 2])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(\\d)(?<name>abc)-(?<number1>\\d+)", expectedGroupsCount: 4), ["name": 2, "number1": 3])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(\\d(?<name>abc)-(?<number1>\\d+))", expectedGroupsCount: 4), ["name": 2, "number1": 3])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(\\d(?<name>abc((?<number1>\\d+)1)))", expectedGroupsCount: 5), ["name": 2, "number1": 4])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?:\\d)", expectedGroupsCount: 1), [:])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?<!>)", expectedGroupsCount: 1), [:])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?<=)", expectedGroupsCount: 1), [:])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?!)", expectedGroupsCount: 1), [:])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?=)", expectedGroupsCount: 1), [:])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?#)", expectedGroupsCount: 1), [:])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?>)", expectedGroupsCount: 1), [:])
    }
    
}
