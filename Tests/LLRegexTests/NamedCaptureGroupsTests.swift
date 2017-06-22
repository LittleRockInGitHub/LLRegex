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
    
        XCTAssertEqual(extractNamedCaptureGroups(in: "\\d", expectedGroupsCount: 0), [:])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "()", expectedGroupsCount: 1), [:])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?<name>abc)", expectedGroupsCount: 1), ["name": 1])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?<name>abc)-(?<number1>\\d+)", expectedGroupsCount: 2), ["name": 1, "number1": 2])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(\\d)(?<name>abc)-(?<number1>\\d+)", expectedGroupsCount: 3), ["name": 2, "number1": 3])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(\\d(?<name>abc)-(?<number1>\\d+))", expectedGroupsCount: 3), ["name": 2, "number1": 3])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(\\d(?<name>abc((?<number1>\\d+)1)))", expectedGroupsCount: 4), ["name": 2, "number1": 4])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?:\\d)", expectedGroupsCount: 0), [:])
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?<!>)", expectedGroupsCount: 0), [:])
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?<=)", expectedGroupsCount: 0), [:])
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?!)", expectedGroupsCount: 0), [:])
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?=)", expectedGroupsCount: 0), [:])
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?#)", expectedGroupsCount: 0), [:])
        XCTAssertEqual(extractNamedCaptureGroups(in: "(?>)", expectedGroupsCount: 0), [:])
        
        XCTAssertEqual(extractNamedCaptureGroups(in: "\\(\\)", expectedGroupsCount: 0), [:])
        XCTAssertEqual(extractNamedCaptureGroups(in: "\\\\()", expectedGroupsCount: 1), [:])
        XCTAssertEqual(extractNamedCaptureGroups(in: "\\(?<name>\\)", expectedGroupsCount: 0), [:])
        XCTAssertEqual(extractNamedCaptureGroups(in: "\\\\(?<name>)", expectedGroupsCount: 1), ["name": 1])
    }
    
    func testNamdCaptureGroupsTypes() {
    
        XCTAssertEqual(Regex("\\d", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        XCTAssertEqual(Regex("()", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        XCTAssertEqual(Regex("(?<name>abc)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 1)
        XCTAssertEqual(Regex("(?<name>abc)-(?<number1>\\d+)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 2)
        XCTAssertEqual(Regex("(\\d)(?<name>abc)-(?<number1>\\d+)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc)-(?<number1>\\d+))", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc((?<number1>\\d+)1)))", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc((?<number1>\\d+)1)))", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc((?<number1>\\d+)1)))", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc((?<number1>\\d+)1)))", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc((?<number1>\\d+)1)))", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 2)
        
        XCTAssertEqual(Regex("(?:\\d)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        XCTAssertEqual(Regex("(?<!>)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        XCTAssertEqual(Regex("(?<=)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        XCTAssertEqual(Regex("(?!)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        XCTAssertEqual(Regex("(?=)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        XCTAssertEqual(Regex("(?#)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        XCTAssertEqual(Regex("(?>)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        
        XCTAssertEqual(Regex("\\(\\)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        XCTAssertEqual(Regex("\\\\()", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        XCTAssertEqual(Regex("\\(?<name>\\)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 0)
        XCTAssertEqual(Regex("\\\\(?<name>)", options: [.namedCaptureGroups]).namedCaptureGroupInfo.count, 1)
    }
    
    func testNamdCaptureGroups() {
        
        let s = "123 normal named (nested) atomic non-capture 456"
        let regex = Regex("(?<!a)(?<=123) (?i)(NORMAL) (?<name>named) (\\((?<nested>nested)\\)) (?>atomic) (?:non-capture) (?=456)(?!a)", options: [.namedCaptureGroups])
        
        XCTAssertEqual(regex.namedCaptureGroupInfo, ["name": 2, "nested": 4])
        
        let match = regex.matches(in: s).first!
        
        XCTAssertEqual(match.groups["name"]!.matched, "named")
        XCTAssertEqual(match.groups["nested"]!.matched, "nested")
        XCTAssertNil(match.groups[""])
    }
}
