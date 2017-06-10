//
//  StringRegexTests.swift
//  LLRegex
//
//  Created by Rock Young on 2017/6/3.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import XCTest
@testable import LLRegex

class StringRegexTests: XCTestCase {
    
    var s: String = "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃zelda\r\n Link™"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReplaceFirst() {
        
        XCTAssertEqual(s.replacingFirst("zelda", with: "$1"), "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃$1\r\n Link™")
        XCTAssertEqual(s.replacingFirst(pattern: "(z)elda", withTemplate: "$1"), "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃z\r\n Link™")
        XCTAssertEqual(s.replacingFirst(pattern: Regex("(z)elda", options: [.caseInsensitive]), withTemplate: "$1"), "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Z™ is so awesome!>\nll™< 塞尔达™最高 3>😃zelda\r\n Link™")
        
        XCTAssertEqual(s.replacingFirst(pattern: Regex("(z)elda", options: [.caseInsensitive]), in: s.range(of: "Zelda™")!.upperBound..<s.endIndex, withTemplate: "$1"), "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃z\r\n Link™")
        
        var result = s
        
        result.replaceFirst("zelda", with: "$1")
        XCTAssertEqual(result, "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃$1\r\n Link™")
        
        result = s
        result.replaceFirst(pattern: "(z)elda", withTemplate: "$1")
        XCTAssertEqual(result, "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃z\r\n Link™")
        
        result = s
        result.replaceFirst(pattern: Regex("(z)elda", options: [.caseInsensitive]), withTemplate: "$1")
        XCTAssertEqual(result, "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Z™ is so awesome!>\nll™< 塞尔达™最高 3>😃zelda\r\n Link™")
        
        
        result = s
        result.replaceFirst(pattern: Regex("(z)elda", options: [.caseInsensitive]), in: s.range(of: "Zelda™")!.upperBound..<s.endIndex, withTemplate: "$1")
        XCTAssertEqual(result, "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃z\r\n Link™")
    }
    
    func testRepalceAll() {
        
        XCTAssertEqual(s.replacingAll("zelda", with: "$1"), "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃$1\r\n Link™")
        XCTAssertEqual(s.replacingAll(pattern: "(z)elda", withTemplate: "$1"), "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃z\r\n Link™")
        XCTAssertEqual(s.replacingAll(pattern: Regex("(z)elda", options: [.caseInsensitive]), withTemplate: "$1"), "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Z™ is so awesome!>\nll™< 塞尔达™最高 3>😃z\r\n Link™")
        
        XCTAssertEqual(s.replacingAll(pattern: Regex("(z)elda", options: [.caseInsensitive]), in: s.range(of: "Zelda™")!.upperBound..<s.endIndex, withTemplate: "$1"), "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃z\r\n Link™")
        
        var result = s
        
        result.replaceAll("zelda", with: "$1")
        XCTAssertEqual(result, "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃$1\r\n Link™")
        
        result = s
        result.replaceAll(pattern: "(z)elda", withTemplate: "$1")
        XCTAssertEqual(result, "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃z\r\n Link™")
        
        result = s
        result.replaceAll(pattern: Regex("(z)elda", options: [.caseInsensitive]), withTemplate: "$1")
        XCTAssertEqual(result, "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Z™ is so awesome!>\nll™< 塞尔达™最高 3>😃z\r\n Link™")
        
        
        result = s
        result.replaceAll(pattern: Regex("(z)elda", options: [.caseInsensitive]), in: s.range(of: "Zelda™")!.upperBound..<s.endIndex, withTemplate: "$1")
        XCTAssertEqual(result, "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃z\r\n Link™")
    }
    
    func testMatching() {
        
        XCTAssertTrue("a1".isMatching("a\\d+"))
        XCTAssertFalse("A1".isMatching("a\\d+"))
        XCTAssertFalse("a".isMatching("a\\d+"))
        XCTAssertFalse("a1b".isMatching("a\\d+"))
        XCTAssertFalse("1".isMatching("a\\d+"))
        
        XCTAssertTrue("a1".isMatching("a\\d+", entirely: false))
        XCTAssertFalse("A1".isMatching("a\\d+", entirely: false))
        XCTAssertFalse("a".isMatching("a\\d+", entirely: false))
        XCTAssertTrue("a1b".isMatching("a\\d+", entirely: false))
        XCTAssertFalse("1".isMatching("a\\d+", entirely: false))
        
        let regex1 = Regex("a\\d+", options: [.caseInsensitive])
        
        XCTAssertTrue("a1".isMatching(regex1))
        XCTAssertTrue("A1".isMatching(regex1))
        XCTAssertFalse("a".isMatching(regex1))
        XCTAssertFalse("a1b".isMatching(regex1))
        XCTAssertFalse("1".isMatching(regex1))
        
        XCTAssertTrue("a1".isMatching(regex1, entirely: false))
        XCTAssertTrue("A1".isMatching(regex1, entirely: false))
        XCTAssertFalse("a".isMatching(regex1, entirely: false))
        XCTAssertTrue("a1b".isMatching(regex1, entirely: false))
        XCTAssertFalse("1".isMatching(regex1, entirely: false))
        
    }
    
    func testSplit() {
    
        let s: String = "0a12b234c34560"
        
        XCTAssertEqual(s.split(seperator: "3"), ["0a12b2", "4c", "4560"])
        XCTAssertEqual(s.split(seperator: "3", maxSplits: 0), ["0a12b234c34560"])
        XCTAssertEqual(s.split(seperator: "3", maxSplits: 1), ["0a12b2", "4c34560"])
        
        XCTAssertEqual(s.split(seperator: "0"), ["a12b234c3456"])
        XCTAssertEqual(s.split(seperator: "0", omittingEmptyString: false), ["", "a12b234c3456", ""])
        XCTAssertEqual(s.split(seperator: "0", maxSplits: 0, omittingEmptyString: false), ["0a12b234c34560"])
        XCTAssertEqual(s.split(seperator: "0", maxSplits: 1, omittingEmptyString: false), ["", "a12b234c34560"])
        
        XCTAssertEqual("".split(seperator: "0"), [])
        XCTAssertEqual("".split(seperator: "0", omittingEmptyString: false), [""])
        
        XCTAssertEqual("ab".split(seperator: ""), ["a", "b"])
        XCTAssertEqual("ab".split(seperator: "", omittingEmptyString: false), ["", "a", "b", ""])
        
        XCTAssertEqual("".split(seperator: ""), [])
        XCTAssertEqual("".split(seperator: "", omittingEmptyString: false), ["", ""])
        
        let regex = Regex("\\d+")
        
        XCTAssertEqual(s.split(seperator: regex), ["a", "b", "c"])
        XCTAssertEqual(s.split(seperator: regex, maxSplits: 0), ["0a12b234c34560"])
        XCTAssertEqual(s.split(seperator: regex, maxSplits: 1), ["a12b234c34560"])
        
        XCTAssertEqual(s.split(seperator: regex, omittingEmptyString: false), ["", "a", "b", "c", ""])
        XCTAssertEqual(s.split(seperator: regex, maxSplits: 0, omittingEmptyString: false), ["0a12b234c34560"])
        XCTAssertEqual(s.split(seperator: regex, maxSplits: 1, omittingEmptyString: false), ["", "a12b234c34560"])
        
        XCTAssertEqual(s.split(seperator: regex.pattern), ["a", "b", "c"])
        XCTAssertEqual(s.split(seperator: regex.pattern, maxSplits: 0), ["0a12b234c34560"])
        XCTAssertEqual(s.split(seperator: regex.pattern, maxSplits: 1), ["a12b234c34560"])
        
        XCTAssertEqual(s.split(seperator: regex.pattern, omittingEmptyString: false), ["", "a", "b", "c", ""])
        XCTAssertEqual(s.split(seperator: regex.pattern, maxSplits: 0, omittingEmptyString: false), ["0a12b234c34560"])
        XCTAssertEqual(s.split(seperator: regex.pattern, maxSplits: 1, omittingEmptyString: false), ["", "a12b234c34560"])
        
        XCTAssertEqual("\\da".split(seperator: "\\d".escapedAsPattern()), ["a"])
        XCTAssertEqual("\\da".split(seperator: "(\\d"), ["\\da"])
        
        
    }

}
