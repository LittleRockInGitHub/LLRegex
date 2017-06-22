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
    
        XCTAssertEqual(Regex("\\d", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        XCTAssertEqual(Regex("()", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        XCTAssertEqual(Regex("(?<name>abc)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 1)
        XCTAssertEqual(Regex("(?<name>abc)-(?<number1>\\d+)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 2)
        XCTAssertEqual(Regex("(\\d)(?<name>abc)-(?<number1>\\d+)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc)-(?<number1>\\d+))", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc((?<number1>\\d+)1)))", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc((?<number1>\\d+)1)))", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc((?<number1>\\d+)1)))", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc((?<number1>\\d+)1)))", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 2)
        XCTAssertEqual(Regex("(\\d(?<name>abc((?<number1>\\d+)1)))", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 2)
        
        XCTAssertEqual(Regex("(?:\\d)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        XCTAssertEqual(Regex("(?<!>)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        XCTAssertEqual(Regex("(?<=)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        XCTAssertEqual(Regex("(?!)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        XCTAssertEqual(Regex("(?=)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        XCTAssertEqual(Regex("(?#)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        XCTAssertEqual(Regex("(?>)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        
        XCTAssertEqual(Regex("\\(\\)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        XCTAssertEqual(Regex("\\\\()", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        XCTAssertEqual(Regex("\\(?<name>\\)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 0)
        XCTAssertEqual(Regex("\\\\(?<name>)", options: [.namedCaptureGroups]).namedCaptureGroupsInfo.count, 1)
    }
    
    func testNamdCaptureGroups() {
        
        let s = "123 normal NAMED (Nested) atomic non-capture 456"
        let regex = Regex("(?#comment)(?<!a)(?<=123) (?i)(NORMAL) (?<name>named) (\\((?<nested>nested)\\)) (?>atomic) (?:non-capture) (?=456)(?!a)", options: [.namedCaptureGroups])
        
        XCTAssertEqual(regex.namedCaptureGroupsInfo, ["name": 2, "nested": 4])
        
        let match = regex.matches(in: s).first!
        
        XCTAssertEqual(match.groups["name"]!.matched, "NAMED")
        XCTAssertEqual(match.groups["nested"]!.matched, "Nested")
        XCTAssertNil(match.groups[""])
    }
    
    func testReplacement() {
        let date = "1978-12-24"
        let named = Regex("((?<year>\\d+)-(?<month>\\d+)-(?<day>\\d+))", options: .namedCaptureGroups)
        let nonNamed = Regex("((?<year>\\d+)-(?<month>\\d+)-(?<day>\\d+))")
        let namedMatch = named.matches(in: date).first!
        let nonNamedMatch = nonNamed.matches(in: date).first!
        
        XCTAssertEqual(namedMatch.replacement(withTemplate: "$2$3$4"), "19781224")
        XCTAssertEqual(namedMatch.replacement(withTemplate: "${year}${month}${day}"), "19781224")
        XCTAssertEqual(namedMatch.replacement(withTemplate: "\\${year}${month}\\\\${day}"), "${year}12\\24")
        XCTAssertEqual(namedMatch.replacement(withTemplate: "$9${unknown}!"), "!")
    
        XCTAssertEqual(nonNamedMatch.replacement(withTemplate: "$2$3$4"), "19781224")
        XCTAssertEqual(nonNamedMatch.replacement(withTemplate: "${year}${month}${day}"), "${year}${month}${day}")
        XCTAssertEqual(nonNamedMatch.replacement(withTemplate: "$9${unknown}!"), "${unknown}!")

    }
}
