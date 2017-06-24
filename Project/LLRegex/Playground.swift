//
//  Playground.swift
//  LLRegex
//
//  Created by Rock Yang on 2017/6/10.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import Foundation

let numbers = Regex("(\\d)(\\d+)(\\d)")

let insensitive = Regex("LLRegex", options: [.caseInsensitive])

let runtimeError = Regex("")    // Runtime error would be raised

let invalid = try? Regex(pattern: "")   // nil returned

let s = "123-45-6789-0-123-45-6789-01234"

let subrange = s.characters.dropFirst(3).startIndex..<s.endIndex

struct Playground {
    
    public func search() {
        
        for match in numbers.matches(in: s) {
            // enumerating
        }
        
        if let first = numbers.matches(in: s).first {
            // first match
        }
        
        let allMatches: [Match] = numbers.matches(in: s).all // all matches
        
        let subrangeMatches = numbers.matches(in: s, options: [.withTransparentBounds], range: subrange)
        
        for case let match in subrangeMatches.dropFirst(1) where match.matched != "45" {
            
        }
    }
    
    public func match() {
        
        if let first = numbers.matches(in: s).first {
            
            first.matched
            first.range
            first.groups.count
            first.groups[1].matched
            first.groups[1].range
            
            let replacement = first.replacement(withTemplate: "$3$2$1")
            
        }
    }
    
    
    public func namedCaptureGroups() {
    
        let named = Regex("(?<year>\\d+)-(?<month>\\d+)-(?<day>\\d+)", options: .namedCaptureGroups)
        let s = "Today is 2017-06-23."
        
        for m in named.matches(in: s) {
            m.groups["year"]?.matched
        }
        
        named.replacingAllMatches(in: s, replacement: .replaceWithTemplate("${month}/${day}/${year}"))
    }
    
    public func replace() {
        
        numbers.replacingFirstMatch(in: s, replacement: .remove)
        
        numbers.replacingAllMatches(in: s, range: subrange, replacement: .replaceWithTemplate("$3$2$1"))
        
        numbers.replacingMatches(in: s) { (idx, match) -> Match.Replacing in
            
            switch idx {
            case 0:
                return .keep    // Keep unchanged
            case 1:
                return .remove  // Remove the matched string
            case 2:
                return .replaceWithTemplate("$1-$3")    // Replace with template
            case 3:
                return .replaceWithString({
                    return String(match.matched.characters.reversed())  // Relace with string
                    }())
            default:
                return .stop    // Stop replacing
            }
        }
    }
    
    public func string() {
        
        "123".isMatching("\\d+")
        "llregex".isMatching(insensitive)
        "123-456".isMatching("\\d+")
        
        "123".replacingAll("1", with: "!")
        "123".replacingAll(pattern: "(\\d)(\\d)", withTemplate: "$2$1")
        
        "123".replacingFirst(pattern: numbers, in: subrange, withTemplate: "!")
        
        s.split(seperator: "\\d")
    }
    
    
}
