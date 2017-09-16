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
    
    /// The matched substring.
    var matchedSubstring: Substring? { get }
    
    /// The matched range.
    var range: Range<String.Index>? { get }
}

extension MatchProtocol {
    
    public var matched: String {
        return matchedSubstring.map(String.init) ?? ""
    }
    
    public var matchedSubstring: Substring? {
        return range.map { searched[$0] }
    }
}


protocol _NSRangeBasedMatch : MatchProtocol {
    
    var nsRange: NSRange { get }
}

extension _NSRangeBasedMatch {
    
    public var range: Range<String.Index>? {
        return nsRange.toRange(in: searched)
    }
    
    public var matched: String {
        guard let r = Range(self.nsRange) else { return "" }
        let utf16Range = String.Index(encodedOffset: r.lowerBound) ..< String.Index(encodedOffset: r.upperBound)
        return String(Substring(searched.utf16[utf16Range]))
    }
}


// MARK: Match

/// A type that represents a match searched by regular expression.
public struct Match : _NSRangeBasedMatch {
    
    /// Options for matching
    public struct Options : OptionSetAdapting {
        
        typealias Adopated = NSRegularExpression.MatchingOptions
        
        public let rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        /// Same as NSRegularExpression.MatchingOptions.anchored
        public static let anchored = Options(adapted: .anchored)
        /// Same as NSRegularExpression.MatchingOptions.withTransparentBounds
        public static let withTransparentBounds = Options(adapted: .withTransparentBounds)
        /// Same as NSRegularExpression.MatchingOptions.withoutAnchoringBounds
        public static let withoutAnchoringBounds = Options(adapted: .withoutAnchoringBounds)
        
        static let adaptedOptions: NSRegularExpression.MatchingOptions = [.anchored,
                                                                          .withTransparentBounds,
                                                                          .withoutAnchoringBounds]
    }
    
    /// The searched string.
    public let searched: String

    /// The wrapped NSTextCheckingResult.
    public let result: NSTextCheckingResult
    
    var nsRange: NSRange {
        return result.range
    }
    
    init?(searched: String, result: NSTextCheckingResult, regex: Regex) {
        self.searched = searched
        self.result = result
        self.regex = regex
    }
    
    /// The searching regex.
    public let regex: Regex
}

extension Match {
    
    /// The captures groups.
    public var groups: CaptureGroups { return CaptureGroups(match: self) }
    
    
    /// A type thats represents capture group in a match.
    public struct CaptureGroup : _NSRangeBasedMatch {
    
        // The index in the match.
        public let index: Int
        
        private let match: Match
        
        // The searched string.
        public var searched: String { return match.searched }
        
        var nsRange: NSRange { return match.result.range(at: index) }
        
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
        
        public subscript(name: String) -> CaptureGroup? {
            return match.regex.namedCaptureGroupsInfo?[name].map { self[$0] }
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
        
        var template = template
        
        if regex.options.contains(.namedCaptureGroups) {
            
            let info = regex.namedCaptureGroupsInfo ?? [:]
            
            struct RE {
                static let named: Regex = Regex("(\\\\*)\\$\\{(\\w+)\\}")
            }
            
            template = RE.named.replacingMatches(in: template) { (_, match) -> Match.Replacing in
                
                guard match.groups[1].matched.utf16.count % 2 == 0 else { return .keep }
                
                if let idx = info[match.groups[2].matched] {
                    return .replaceWithTemplate("$1\\$\(idx)")
                } else {
                    return .remove
                }
            }
        }
        
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

