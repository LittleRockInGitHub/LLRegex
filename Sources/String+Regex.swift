//
//  String+Regex.swift
//  LRegex
//
//  Created by Rock Young on 2017/5/31.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import Foundation


extension String {
    
    // MARK: Matching
    
    /**
     Returns whether `self` is matching given pattern.
     - parameter pattern: An element which is possible to be converted to `Regex`.
     - parameter entirely: Indicats whether should matches the string entirely. `true` by default.
     - returns: Whether 'self' is matching given pattern. `false` if regex conversion failed.
     */
    public func isMatching(_ pattern: RegexConvertible, entirely: Bool = true) -> Bool {
        
        guard let regex = (entirely ? try? Regex(pattern: "\\A(:?\(pattern.pattern))\\Z", options: pattern.options) : pattern.asRegex) else { return false }
        
        return regex.matches(in: self).first != nil
    }
    
    // MARK: Replace All
    
    /**
     Returns a string made by replacing all matches in `self` searched by given pattern with given template.
     - parameter pattern: An element which is possible to be converted to `Regex`.
     - parameter range: The searched range. 'nil' indicates the whole range.
     - parameter template: The template string.
     - returns: A string made by replacing all matches in `self`. The original string is returned if regex conversion failed.
     */
    public func replacingAll(pattern: RegexConvertible, in range : Range<String.Index>? = nil, withTemplate template: String) -> String {
        return pattern.asRegex?.replacingAllMatches(in: self, range: range,replacement: .replaceWithTemplate(template)) ?? self
    }
    
    /**
     Returns a string made by replacing all given string with another string.
     - parameter string: A string to search.
     - parameter range: The searched range. 'nil' indicates the whole range.
     - parameter replacement: The replacement string.
     - returns: A string made by replacing all given string with another string.
     */
    public func replacingAll(_ string: String, in range : Range<String.Index>? = nil, with replacement: String) -> String {
        return string.escapedAsPattern().asRegex!.replacingAllMatches(in: self, replacement: .replaceWithString(replacement))
    }

    /**
     Replaces all matches in `self` searched by given pattern with given template. Nothing happened if regex conversion failed.
     - parameter pattern: An element which is possible to be converted to `Regex`.
     - parameter range: The searched range. 'nil' indicates the whole range.
     - parameter template: The template string.
     */
    public mutating func replaceAll(pattern: RegexConvertible, in range : Range<String.Index>? = nil, withTemplate template: String) {
        
        self = replacingAll(pattern: pattern, in: range, withTemplate: template)
    }
    
    /**
     Replaces all given string with another string.
     - parameter string: A string to search.
     - parameter range: The searched range. 'nil' indicates the whole range.
     - parameter replacement: The replacement string.
     */
    public mutating func replaceAll(_ string: String, in range : Range<String.Index>? = nil, with replacement: String) {
        self = replacingAll(string, in: range, with: replacement)
    }
    
    // MARK: Replace First
    
    /**
     Returns a string made by replacing the first match in `self` searched by given pattern with given template.
     - parameter pattern: An element which is possible to be converted to `Regex`.
     - parameter range: The searched range. 'nil' indicates the whole range.
     - parameter template: The template string.
     - returns: A string made by replacing the first match in `self`. The original string is returned if regex conversion failed.
     */
    public func replacingFirst(pattern: RegexConvertible, in range : Range<String.Index>? = nil, withTemplate template: String) -> String {
        
        return pattern.asRegex?.replacingFirstMatch(in: self, range: range, replacement: .replaceWithTemplate(template)) ?? self
    }

    /**
     Returns a string made by replacing the first given string with another string.
     - parameter string: A string to search.
     - parameter range: The searched range. 'nil' indicates the whole range.
     - parameter replacement: The replacement string.
     - returns: A string made by replacing the first given string with another string.
     */
    public func replacingFirst(_ string: String, in range : Range<String.Index>? = nil, with replacement: String) -> String {
        
        return string.escapedAsPattern().asRegex!.replacingFirstMatch(in: self, range: range, replacement: .replaceWithString(replacement))
    }

    /**
     Replaces the first match in `self` searched by given pattern with given template. Nothing happened if regex conversion failed.
     - parameter pattern: An element which is possible to be converted to `Regex`.
     - parameter range: The searched range. 'nil' indicates the whole range.
     - parameter template: The template string.
     */
    public mutating func replaceFirst(pattern: RegexConvertible, in range : Range<String.Index>? = nil, withTemplate template: String) {
        self = replacingFirst(pattern: pattern, in: range, withTemplate: template)
    }
    
    /**
     Replaces the first given string with another string.
     - parameter string: A string to search.
     - parameter range: The searched range. 'nil' indicates the whole range.
     - parameter replacement: The replacement string.
     */
    public mutating func replaceFirst(_ string: String, in range : Range<String.Index>? = nil, with replacement: String) {
        self = replacingFirst(string, in: range, with: replacement)
    }
    
    // MARK: Split
    
    /**
     Returns string array, in order, around elements equal to the given element.
     - parameter seperator: The pattern thats should be split upon.
     - parameter maxSplits: The maximum number of times to split 'self', or one less than the number of strings to return. `maxSplits` must be greater than or equal to zero. `Int.max` by default.
     - parameter omittingEmptyString: If true, only nonempty strings are returned. 'true' by default.
     - returns: The strings, splits from 'self'.
    */
    public func split(seperator: RegexConvertible, maxSplits: Int = Int.max, omittingEmptyString: Bool = true) -> [Substring] {
        
        precondition(maxSplits >= 0)
        
        var reval: [Substring] = []
        
        let appendRange: (Range<String.Index>) -> Void
        
        if omittingEmptyString {
            appendRange = {
                if !$0.isEmpty {
                    reval.append(self[$0])
                }
            }
        } else {
            appendRange = {
                reval.append(self[$0])
            }
        }
        
        var current: String.Index = startIndex
        
        if let regex = seperator.asRegex {
            
            for (idx, match) in regex.matches(in: self).enumerated() {
                
                guard idx < maxSplits, let range = match.range else { break }
                
                appendRange(current..<range.lowerBound)
                
                current = range.upperBound
            }
        }
        
        appendRange(current..<endIndex)
        
        return reval
    }
}
