//
//  NSRange+Util.swift
//  LLRegex
//
//  Created by Rock Young on 2017/6/2.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import Foundation

extension NSRange {
    
    init(start: Int, end: Int) {
        self.init(location: start, length: end - start)
    }
    
    var isEmpty: Bool {
        return length == 0
    }
    
    func contains(_ loc: Int) -> Bool {
        return NSLocationInRange(loc, self)
    }
    
    var start: Int {
        get {
            return location
        }
        set {
            self = NSRange(start: newValue, end: end)
        }
    }
    
    var end: Int {
        get {
            return NSMaxRange(self)
        }
        set {
            self = NSRange(start: start, end: newValue)
        }
    }

    
}

#if swift(>=3.2)
#else
    extension NSRange : Equatable {
        public static func ==(lhs: NSRange, rhs: NSRange) -> Bool {
            return NSEqualRanges(lhs, rhs)
        }
    }
#endif

