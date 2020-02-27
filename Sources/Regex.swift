//
//  Regex.swift
//  LLRegex
//
//  Created by Rock Young on 2017/5/31.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import Foundation


/// A type that is used to reprensent and apply regular expreesion to Unicode strings, which wrapps NSRegularExpression.
public struct Regex {
    
    /// Options of Regex.
    public struct Options : OptionSetAdapting {
        
        typealias Adapted = NSRegularExpression.Options
        
        private static let reserved: UInt = 16
    
        public let rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        /// Same as NSRegularExpression.Option.caseInsensitive
        public static let caseInsensitive = Options(adapted: .caseInsensitive)
        /// Same as NSRegularExpression.Option.allowCommentsAndWhitespace
        public static let allowCommentsAndWhitespace = Options(adapted: .allowCommentsAndWhitespace)
        /// Same as NSRegularExpression.Option.ignoreMetacharacters
        public static let ignoreMetacharacters = Options(adapted: .ignoreMetacharacters)
        /// Same as NSRegularExpression.Option.dotMatchesLineSeparators
        public static let dotMatchesLineSeparators = Options(adapted: .dotMatchesLineSeparators)
        /// Same as NSRegularExpression.Option.anchorsMatchLines
        public static let anchorsMatchLines = Options(adapted: .anchorsMatchLines)
        /// Same as NSRegularExpression.Option.useUnixLineSeparators
        public static let useUnixLineSeparators = Options(adapted: .useUnixLineSeparators)
        /// Same as NSRegularExpression.Option.useUnicodeWordBoundaries
        public static let useUnicodeWordBoundaries = Options(adapted: .useUnicodeWordBoundaries)
        /// Enables named capture groups feature
        public static let namedCaptureGroups = Options(rawValue: 1 << reserved)
        
        static let adaptedOptions: NSRegularExpression.Options = [.caseInsensitive,
                                                                  .allowCommentsAndWhitespace,
                                                                  .ignoreMetacharacters,
                                                                  .dotMatchesLineSeparators,
                                                                  .anchorsMatchLines,
                                                                  .useUnixLineSeparators,
                                                                  .useUnicodeWordBoundaries]
        
    }
    
    private let _regularExpression: NSRegularExpression
    
    /// Wrapped NSRegularExpression.
    public var regularExpression: NSRegularExpression {
        get {
            return _regularExpression
        }
        set {
            self = Regex(regularExpression: newValue)
        }
    }
    
    /**
     Creates a `Regex` with unchecked string literal and options. Runtime error is raised if the unchecked pattern is invalid.
     - parameter uncheckedPattern: The unchecked regulare expression pattern.
     - parameter options: The regular expression options that are applied to the expression during matching. Empty options by default.
     - returns: An instance with given pattern and options. Runtime error is raised if the unchecked pattern is invalid.
    */
    public init(_ uncheckedPattern: StaticString, options: Options = []) {
        do {
            try self.init(pattern: uncheckedPattern.description, options: options)
        } catch {
            fatalError("Pattern \(uncheckedPattern) is invalid.")
        }
    }
    
    /**
     Creates a `Regex` with pattern and options.
     - parameter pattern: The regulare expression pattern.
     - parameter options: The regular expression options that are applied to the expression during matching. Empty options by default.
     - returns: An instance with given pattern and options.
     - throws: An error if failed.
     */
    public init(pattern: String, options: Options = []) throws {
        let re = try NSRegularExpression(pattern: pattern, options: options.toAdapted())
        self._regularExpression = re
        self._options = options
        
        if #available(iOS 9, *), options.contains(.namedCaptureGroups) {
            self.namedCaptureGroupsInfo = extractNamedCaptureGroups(in: pattern, expectedGroupsCount: re.numberOfCaptureGroups)
        } else {
            self.namedCaptureGroupsInfo = [:]
        }
    }
    
    /**
     Creates a `Regex` with an instance of NSRegularExpression.
     - parameters regularExpression: A compiled NSRegulareExpression.
     - returns: An instance wrapping given NSRegularExpression.
     */
    
    public init(regularExpression: NSRegularExpression) {
        self._regularExpression = regularExpression
        self._options = Options(adapted: regularExpression.options)
        self.namedCaptureGroupsInfo = [:]
    }
    
    
    /// The pattern value.
    public var pattern: String { return regularExpression.pattern }
    
    /**
     Set a new pattern value.
     - parameter pattern: A new pattern.
     - throws: An error if pattern is invalid.
     */
    public mutating func setPattern(_ pattern: String) throws {
        self = try Regex(pattern: pattern, options: self.options)
    }
    
    private let _options: Options
    
    /// The options value.
    public var options: Options {
        get {
            return _options
        }
        set {
            self = try! Regex(pattern: pattern, options: newValue)
        }
    }
    
    
    /// The number of capture groups.
    public var numberOfCaptureGroups: Int { return regularExpression.numberOfCaptureGroups }
    
    let namedCaptureGroupsInfo: [String: Int]?
    
}

// MARK: Equatable

extension Regex : Equatable {

    public static func ==(lhs: Regex, rhs: Regex) -> Bool {
        return lhs.pattern == rhs.pattern && lhs.options == rhs.options
    }
}

// MARK: Hashable

extension Regex : Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(pattern.hashValue + options.rawValue.hashValue * 100)
    }
}

// MARK: Match

extension Regex {

    /**
     Returns a sequence producing matches **lazily** in the searched string.
     - parameter string: The searched string.
     - parameter options: The Match options.
     - parameter range: The searched range. `nil` indicates searching in the whole range of given string. `nil` by default.
     */
    public func matches(in string: String, options: Match.Options = [], range: Range<String.Index>? = nil) -> Match.Sequence {
        
        return Match.Sequence(iterator: Match.Iterator(regex: self, searched: string, options: options, range: range))
    }
}

extension Match {
    
    /// A Iterator type iterates the matches.
    public struct Iterator: IteratorProtocol {
    
        let searched: String
        let regex: Regex!
        let options: NSRegularExpression.MatchingOptions
        let range: NSRange?
        
        private var lastMatched: NSRange?
        private var current: NSRange?
        
        init() {
            self.searched = ""
            self.options = []
            self.range = nil
            self.regex = nil
        }
        
        init(regex: Regex, searched: String, options: Options, nsRange: NSRange) {
            self.regex = regex
            self.searched = searched
            
            self.options = options.toAdapted().union(.reportCompletion)
            
            self.range = nsRange
            self.current = nsRange
        }
        
        init(regex: Regex, searched: String, options: Options, range: Range<String.Index>? = nil) {
            
            self.init(regex: regex, searched: searched, options: options, nsRange: (range ?? searched.startIndex..<searched.endIndex).toNSRange(in: searched))
        }
        
        public mutating func next() -> Match? {
            
            guard let current = current else { return nil }
            
            var match: Match?
            
            regex.regularExpression.enumerateMatches(in: searched, options: options, range: current) { (r, flags, stop) in
                
                guard let r = r else {
                    stop.pointee = true
                    match = nil
                    return
                }
                
                if lastMatched != r.range, let m = Match(searched: searched, result: r, regex: regex)  {
                    stop.pointee = true
                    match = m
                }
            }
            
            lastMatched = match?.result.range
            
            if let match = match {
                self.current?.start = match.result.range.end
                return match
            } else {
                self.current = nil
                return nil
            }
        }

        
    }
    
    /// A Sequence type produces matches.
    public struct Sequence: Swift.Sequence {
    
        let iterator: Iterator
        
        public func makeIterator() -> Iterator {
            return iterator
        }
    }
}

extension Match.Sequence {
    
    /// Returns the first match. `nil` if no matches.
    public var first: Match? {
        return self.first { _ in true }
    }
    
    /// Returns all matches.
    public var all: [Match] {
        return self.iterator.makeAllMatches()
    }
}

extension Match.Iterator {

    func makeAllMatches() -> [Match] {
    
        guard let range = self.range else { return [] }
        
        return self.regex.regularExpression.matches(in: searched, options: options, range: range).compactMap({ Match(searched: searched, result: $0, regex: regex)
        })
    }
}

// MARK: Replace

extension Match {

    /**
     `Replacing` defines the actions in match replacing.
     * stop: Stops the replacing process.
     * replaceWithString(_): Replaces the range of match with given string.
     * replaceWithString(_): Replace the range of match with given template for match.
     * remove: Removes string in the range of match.
     * keep: Keep unchanged.
     */
    public enum Replacing {
        /// Stops the replacing process.
        case stop
        /// Replaces the range of match with given string.
        case replaceWithString(String)
        /// Replace the range of match with given template for match.
        case replaceWithTemplate(String)
        /// Removes string in the range of match.
        case remove
        ///  Keep unchanged.
        case keep
    }
}

extension Regex {
    
    /**
     Returns a string by replacing the first match in the searched string.
     - parameter string: The searched string.
     - parameter options: The Match options. Empty options by default.
     - parameter range: The searched range. 'nil' indicates searching of the whole string. 'nil' by default.
     - parameter replacement: The replacement action.
     - returns: A string by replacing the first match in the searched string.
     */
    public func replacingFirstMatch(in string: String, options: Match.Options = [], range: Range<String.Index>? = nil, replacement: Match.Replacing) -> String {
        
        switch replacement {
        case .stop, .keep:
            return string
        default:
            return replacingMatches(in: string, options: options, range: range) { idx, match in
                return idx == 0 ? replacement : .stop
            }
        }
    }
    
    /**
     Returns a string by replacing matches in the searched string.
     - parameter string: The searched string.
     - parameter options: The Match options. Empty options by default.
     - parameter range: The searched range. 'nil' indicates searching of the whole string. 'nil' by default.
     - parameter replacement: The replacement action.
     - returns: A string by replacing matches in the searched string
     */
    public func replacingAllMatches(in string: String, options: Match.Options = [], range: Range<String.Index>? = nil, replacement: Match.Replacing) -> String {
        
        switch replacement {
        case .stop, .keep:
            return string
        default:
            return replacingMatches(in: string, options: options, range: range) { _, _ in return replacement }
        }
    }
    
    /**
     Returns a string by replacing all matches in the searched string.
     - parameter string: The searched string.
     - parameter options: The Match options. Empty options by default.
     - parameter range: The searched range. 'nil' indicates searching of the whole string. 'nil' by default.
     - parameter replacing: The replacing handler.
     - returns: A string by replacing all matches in the searched string.
     */
    public func replacingMatches(in string: String, options: Match.Options = [], range: Range<String.Index>? = nil, replacing: (_ idx: Int, _ match: Match) throws -> Match.Replacing) rethrows -> String {
        
        var replacements: [(Range<String.Index>, String)] = []
        
        Iterating: for (idx, match) in IteratorSequence(Match.Iterator(regex: self, searched: string, options: options, range: range)).enumerated() {
        
            let replacement: String
            
            switch try replacing(idx, match) {
            case .stop:
                break Iterating
            case .keep:
                continue
            case .remove:
                replacement = ""
            case .replaceWithString(let s):
                replacement = s
            case .replaceWithTemplate(let template):
                replacement = match.replacement(withTemplate: template)
            }
            
            if let range = match.range {
                replacements.append((range, replacement))
            }
        }
        
        var reval = string
        replacements.reversed().forEach { reval.replaceSubrange($0.0, with: $0.1) }
        
        return reval
    }

}

// MARK: Pattern Escape

extension Regex {

    //// Returns a string by adding backslash escapes as necessary to protect any characters that would match as pattern metacharacters.
    public static func escapedPattern(for string: String) -> String {
        return NSRegularExpression.escapedPattern(for: string)
    }
}

extension String {
    
    /// Returns a string by adding backslash escapes as necessary to protect any characters that would match as pattern metacharacters.
    public func escapedAsPattern() -> String {
        return Regex.escapedPattern(for: self)
    }
}

// MARK: RegexConvertible


/// A type that is possible to be converted to `Regex'.
public protocol RegexConvertible {
    
    /// Returns a converted `Regex`.
    var asRegex: Regex? { get }
    
    /// The pattern value.
    var pattern: String { get }
    
    /// The options value.
    var options: Regex.Options { get }
}

extension RegexConvertible {

    public var asRegex: Regex? {
        return try? Regex(pattern: self.pattern, options: self.options)
    }
    
    public var options: Regex.Options { return [] }
}

extension Regex : RegexConvertible {
    
    public var asRegex: Regex? { return self }
}

extension String : RegexConvertible {
    
    public var pattern: String { return "(?:\(self))" }
}

// MARK: NamedCaptureGroup

func extractNamedCaptureGroups(in pattern: String, expectedGroupsCount: Int) -> [String: Int]? {
    struct RE {
        static let captureGroup: Regex = Regex("(\\\\*+)\\((?!\\?)")
        static let namedCaptureGroup: Regex = Regex("(\\\\*+)\\(\\?<(\\w+)>")
    }
    
    let captureGroups = RE.captureGroup.matches(in: pattern).filter { $0.groups[1].matched.utf16.count % 2 == 0 }
    let namedCaptureGroups = RE.namedCaptureGroup.matches(in: pattern).filter { $0.groups[1].matched.utf16.count % 2 == 0 }
    
    guard captureGroups.count + namedCaptureGroups.count == expectedGroupsCount else { return nil }
    
    let allGroups = (captureGroups + namedCaptureGroups).sorted { $0.range!.lowerBound < $1.range!.lowerBound }
    
    var reval = [String: Int]()
    
    for (idx, match) in allGroups.enumerated() {
        guard match.regex == RE.namedCaptureGroup else { continue }
        reval[match.groups[2].matched] = idx + 1
    }
    
    return reval
}

