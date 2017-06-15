//
//  LLRegexTests.swift
//  LLRegexTests
//
//  Created by Rock Young on 2017/5/31.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import XCTest
@testable import LLRegex

class LLRegexTests: XCTestCase {
    
    var tmRegex: Regex!
    var zeldaRegex: Regex!
    var s: String = "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃zelda\r\n Link™"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        tmRegex = Regex("((\\S)(\\S*)(\\S))™")
        zeldaRegex = Regex("(zelda|link)(™)?", options: [.caseInsensitive])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMatchFirst() {
        
        XCTAssertEqual(tmRegex.matches(in: s).first?.matched, "😊😾LL™")
        XCTAssertEqual(zeldaRegex.matches(in: s).first?.matched, "Zelda™")
        
    }
    
    func testMatchAll() {
    
        XCTAssertEqual(tmRegex.matches(in: s).all.map { $0.matched }, ["😊😾LL™", "ゼルダ™", "Zelda™", "ll™", "塞尔达™", "Link™"])
        XCTAssertEqual(zeldaRegex.matches(in: s).all.count, 3)
        XCTAssertEqual(zeldaRegex.matches(in: s).all[1].matched, "zelda")
    }
    
    func testMatchSequence() {
        
        XCTAssertEqual(tmRegex.matches(in: s).prefix(2).map { $0.matched }, ["😊😾LL™", "ゼルダ™"])
        XCTAssertEqual(zeldaRegex.matches(in: s).suffix(2).map { $0.matched }, ["zelda", "Link™"])
        
        for (idx, _) in tmRegex.matches(in: s).dropFirst().enumerated() {
            XCTAssertTrue(idx < 5)
        }
    }
    
    func testMatchRange() {
        
        var range = 0..<5
        XCTAssertEqual(tmRegex.matches(in: s, range: s.range(offsetBy: range)).all.count, 1)
        
        range = 0..<4
        XCTAssertEqual(tmRegex.matches(in: s, range: s.range(offsetBy: range)).all.count, 0)
        
        range = 20..<73
        XCTAssertEqual(tmRegex.matches(in: s, range: s.range(offsetBy: range)).all.count, 4)
        
        range = 20..<72
        XCTAssertEqual(tmRegex.matches(in: s, range: s.range(offsetBy: range)).all.count, 3)
    }
    
    
    func testReplaceFirst() {
    
        XCTAssertEqual(tmRegex.replacingFirstMatch(in: s, replacement: .keep), s)
        XCTAssertEqual(tmRegex.replacingFirstMatch(in: s, replacement: .stop), s)
        XCTAssertEqual(tmRegex.replacingFirstMatch(in: s, replacement: .remove), "abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃zelda\r\n Link™")
        XCTAssertEqual(tmRegex.replacingFirstMatch(in: s, replacement: .replaceWithString("$0$1$2$3 ")), "$0$1$2$3 abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃zelda\r\n Link™")
        XCTAssertEqual(tmRegex.replacingFirstMatch(in: s, replacement: .replaceWithTemplate("$0$1$2$3 ")), "😊😾LL™😊😾LL😊😾L abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃zelda\r\n Link™")

    }
    
    func testRepalceAll() {
        XCTAssertEqual(tmRegex.replacingAllMatches(in: s, replacement: .keep), s)
        XCTAssertEqual(tmRegex.replacingAllMatches(in: s, replacement: .stop), s)
        XCTAssertEqual(tmRegex.replacingAllMatches(in: s, replacement: .remove), "abc 1™ <😍 の伝説  is so awesome!>\n< 最高 3>😃zelda\r\n ")
        XCTAssertEqual(tmRegex.replacingAllMatches(in: s, replacement: .replaceWithString("($4$3$2)")), "($4$3$2)abc 1™ <😍 ($4$3$2)の伝説 ($4$3$2) is so awesome!>\n($4$3$2)< ($4$3$2)最高 3>😃zelda\r\n ($4$3$2)")
        XCTAssertEqual(tmRegex.replacingAllMatches(in: s, replacement: .replaceWithTemplate("($4$3$2)")), "(L😾L😊)abc 1™ <😍 (ダルゼ)の伝説 (aeldZ) is so awesome!>\n(ll)< (达尔塞)最高 3>😃zelda\r\n (kinL)")
    }
    
    func testReplaceCustom() {
    
        let result = tmRegex.replacingMatches(in: s) { (idx, match) -> Match.Replacing in
            
            return .replaceWithTemplate("(\(idx + 1): $1, \(String(match.groups[1].matched!.characters.reversed())))")
        }
        
        XCTAssertEqual(result, "(1: 😊😾LL, LL😾😊)abc 1™ <😍 (2: ゼルダ, ダルゼ)の伝説 (3: Zelda, adleZ) is so awesome!>\n(4: ll, ll)< (5: 塞尔达, 达尔塞)最高 3>😃zelda\r\n (6: Link, kniL)")
    }
    
    func testReplaceRange() {
        
        XCTAssertEqual(tmRegex.replacingFirstMatch(in: s, range: s.range(offsetBy: 0..<4), replacement: .remove), "😊😾LL™abc 1™ <😍 ゼルダ™の伝説 Zelda™ is so awesome!>\nll™< 塞尔达™最高 3>😃zelda\r\n Link™")
        XCTAssertEqual(tmRegex.replacingAllMatches(in: s, options: [], range: s.range(of: "™")!.upperBound..<s.endIndex, replacement: .replaceWithString("😸")), "😊😾LL™abc 1™ <😍 😸の伝説 😸 is so awesome!>\n😸< 😸最高 3>😃zelda\r\n 😸")
        
        let result = tmRegex.replacingMatches(in: s, range: s.startIndex..<s.range(of: "\r\n")!.upperBound) { (idx, match) -> Match.Replacing in
            
            return .replaceWithTemplate("(\(idx + 1): $1, \(String(match.groups[1].matched!.characters.reversed())))")
        }
        
        XCTAssertEqual(result, "(1: 😊😾LL, LL😾😊)abc 1™ <😍 (2: ゼルダ, ダルゼ)の伝説 (3: Zelda, adleZ) is so awesome!>\n(4: ll, ll)< (5: 塞尔达, 达尔塞)最高 3>😃zelda\r\n Link™")
    }
    
    func testMatch() {
    
        let all = tmRegex.matches(in: s).all
        
        XCTAssertEqual(all[0].range, s.range(of: "😊😾LL™"))
        XCTAssertEqual(all[0].matched, "😊😾LL™")
        XCTAssertEqual(all[0].groups[0].matched, "😊😾LL™")
        XCTAssertEqual(all[0].groups[1].matched, "😊😾LL")
        XCTAssertEqual(all[0].groups[2].matched, "😊")
        XCTAssertEqual(all[0].groups[3].matched, "😾L")
        XCTAssertEqual(all[0].groups[4].matched, "L")
        
        XCTAssertEqual(all[3].matched, "ll™")
        XCTAssertEqual(all[3].groups[0].matched, "ll™")
        XCTAssertEqual(all[3].groups[1].matched, "ll")
        XCTAssertEqual(all[3].groups[2].matched, "l")
        XCTAssertEqual(all[3].groups[3].matched, "")
        XCTAssertEqual(all[3].groups[4].matched, "l")
        
        let notFoundGroup = zeldaRegex.matches(in: s).all[1].groups[2]
        XCTAssertNil(notFoundGroup.matched)
        XCTAssertNil(notFoundGroup.range)
    }
    
    func testRegex() {
    
        let regex1 = Regex("\\d+")
        let regex2 = Regex("\\d+")
        let regex3 = Regex("\\d+", options: [.caseInsensitive])
        let regex4 = Regex("\\D+", options: [.caseInsensitive])
        
        XCTAssertEqual(regex1, regex2)
        XCTAssertNotEqual(regex1, regex3)
        XCTAssertNotEqual(regex3, regex4)
        
        XCTAssertEqual(regex1.hashValue, regex2.hashValue)
        XCTAssertNotEqual(regex1.hashValue, regex3.hashValue)
        XCTAssertNotEqual(regex3.hashValue, regex4.hashValue)
        
        XCTAssertNil(try? Regex(pattern: "(\\d"))
        XCTAssertNotNil(try? Regex(pattern: "()"))
    }
    
    func testRegexPerformance() {
        let content: String = try! String(contentsOf: Bundle(for: LLRegexTests.self).url(forResource: "LargeContent", withExtension: "txt")!)
        
        let pattern: String = "^\\s*0x([A-F0-9]+) - \\s*0x([A-F0-9]+) \\s*\\+?(.+?) .*? \\<([A-F0-9]{8}-?[A-F0-9]{4}-?[A-F0-9]{4}-?[A-F0-9]{4}-?[A-F0-9]{12})\\>"
        
        let regex: Regex = try! Regex(pattern: pattern, options: [.caseInsensitive, .anchorsMatchLines])
        let nsRegex: NSRegularExpression = try! NSRegularExpression(pattern: pattern, options: [NSRegularExpression.Options.caseInsensitive, NSRegularExpression.Options.anchorsMatchLines])
        
        var date: Date
        var match: [String] = []
        
        date = Date()
        match = regex.matches(in: content).all.map { $0.groups[1].matched! }
        let interval1 = Date().timeIntervalSince(date)
        Swift.print("regex: ", interval1)
        Swift.print(match.count)
        
        date = Date()
        let nsContent: NSString = content as NSString
        match = nsRegex.matches(in: content, range: NSRange(0..<nsContent.length)).map({ nsContent.substring(with: $0.rangeAt(1)) as String })
        let interval2 = Date().timeIntervalSince(date)
        Swift.print("nsRegex: ", interval2)
        Swift.print(match.count)
        
        XCTAssertLessThan(interval1, interval2 * 10)
    }
}
