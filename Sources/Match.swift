//
//  Match.swift
//  LLRegex
//
//  Created by Rock Young on 2017/5/31.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import Foundation


// MARK: MatchProtocol

//// A type that repsents a match.
public protocol MatchProtocol {
    
    /// The searched string.
    var searched: String { get }
    
    /// The matched string.
    var matched: String { get }
    
    /// The matched range.
    var range: Range<String.Index> { get }
}

extension MatchProtocol {
    
    public var matched: String {
        return searched.substring(with: range)
    }
}

// MARK: Match

/// A type that represents a match searched by regular expression.
public struct Match : MatchProtocol {
    
    public typealias Options = NSRegularExpression.MatchingOptions
    
    /// The searched string.
    public let searched: String

    /// The wrapped NSTextCheckingResult.
    public let result: NSTextCheckingResult
    
    init?(searched: String, result: NSTextCheckingResult) {
        
        guard let range = result.range.toRange(in: searched) else { return nil }
        
        self.searched = searched
        self.result = result
        self.range = range
    }
    
    /// The searching regex.
    public var regex: Regex { return Regex(regularExpression: result.regularExpression!) }
    
    /// The matched range.
    public let range: Range<String.Index>
}

extension Match {
    
    /// The captures groups.
    public var groups: CaptureGroups { return CaptureGroups(match: self) }
    
    
    /// A type thats represents capture group in a match.
    public struct CaptureGroup {
        
        // The index in the match.
        public let index: Int
        
        private let match: Match
        
        // The searched string.
        public var searched: String { return match.searched }
        
        // The range in the searched string.
        public var range: Range<String.Index>? {
            return match.result.rangeAt(index).toRange(in: searched)
        }
        
        // The matched string.
        public var matched: String? { return range.map { searched.substring(with: $0) } }
        
        init(index: Int, match: Match) {
            self.match = match
            self.index = index
        }
    }
    
    /// A collection that represents caputure groups.
    public struct CaptureGroups : RandomAccessCollection {
        
        private let match: Match
        
        public typealias Element = CaptureGroup
        
        public typealias Index = Int
        
        public subscript(index: Int) -> CaptureGroup {
            
            return CaptureGroup(index: index, match: match)
        }
        
        init(match: Match) {
            self.match = match
        }
        
        public var startIndex: Int { return 0 }
        
        public var endIndex: Int { return match.result.numberOfRanges }
    }
}

// MARK: Replacement

extension Match {
    
    /**
     Returns a replacement string by performing template substitution.
     - parameter template: The template for substitution.
     - returns: The replacement string.
     */
    public func replacement(withTemplate template: String) -> String {
        return result.regularExpression!.replacementString(for: result, in: searched, offset: 0, template: template)
    }
}

// MARK: Template Escape

extension Match {

    /// Returns a template string by adding backslash escapes as necessary to protect any characters that would match as pattern metacharacters
    public static func escapedTemplate(for string: String) -> String {
        return NSRegularExpression.escapedTemplate(for: string)
    }
}

extension String {
    
    /// Returns a template string by adding backslash escapes as necessary to protect any characters that would match as pattern metacharacters
    public func escapedAsTemplate() -> String {
        return Match.escapedTemplate(for: self)
    }
}

