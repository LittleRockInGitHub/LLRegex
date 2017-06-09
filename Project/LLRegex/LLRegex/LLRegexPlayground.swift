//
//  LLRegexPlayground.swift
//  LLRegex
//
//  Created by Rock Yang on 2017/6/7.
//  Copyright © 2017年 Rock Yang. All rights reserved.
//

import Foundation

let numbers = Regex("(\\d)(\\d+)(\\d)")!

let insensitive = Regex("LLRegex", options: [.caseInsensitive])!

let invalid = Regex("")

let s = "123-45-6789-0-123-45-6789-0"

let subrange = s.characters.dropFirst(3).startIndex..<s.endIndex

struct Example {

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
