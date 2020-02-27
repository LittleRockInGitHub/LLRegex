//
//  String+Util.swift
//  LLRegex
//
//  Created by Rock Young on 2017/5/31.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import Foundation


extension Range where Bound == String.Index {
    
    func toNSRange(in string: String) -> NSRange {
        return NSRange(string.utf16Offset(fromIndex: lowerBound)..<string.utf16Offset(fromIndex: upperBound))
    }
}


extension NSRange {
    
    func toRange(in string: String) -> Range<String.Index>? {
        
        guard let range = Range(self), let start = string.index(fromUTF16Offset: range.lowerBound), let end = string.index(fromUTF16Offset: range.upperBound) else { return nil }
        
        return start..<end
    }
}

extension String {
    
    var nsRange: NSRange {
        return (startIndex..<endIndex).toNSRange(in: self)
    }
    
    func index(fromUTF16Offset offset: Int) -> String.Index? {
        #if swift(>=3.2)
            return String.Index(utf16Offset: offset, in: self)
        #else
            return UTF16View.Index(offset).samePosition(in: self)
        #endif
    }
    
    func utf16Offset(fromIndex index: String.Index) -> Int {
        #if swift(>=3.2)
            return index.utf16Offset(in: self)
        #else
            return utf16.startIndex.distance(to: index.samePosition(in: utf16))
        #endif
    }
    
}

