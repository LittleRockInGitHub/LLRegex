//
//  Range+Util.swift
//  LLRegex
//
//  Created by Rock Young on 2017/6/2.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import Foundation


protocol _RangeProtocol {
    
    associatedtype Bound: Comparable
    
    var lowerBound: Bound { get }
    
    var upperBound: Bound { get }
    
    init(uncheckedBounds bounds: (lower: Bound, upper: Bound))
    
    var isEmpty: Bool { get }
    
    func relative<C: Collection>(to collection: C) -> Range<C.Index> where C.IndexDistance == Bound
}

protocol _CloseRangeProtocol : _RangeProtocol {
    
}

extension _RangeProtocol {
    
    func relative<C: Collection>(to collection: C) -> Range<C.Index> where C.IndexDistance == Bound {
        let start = collection.index(collection.startIndex, offsetBy: lowerBound)
        let end = collection.index(collection.startIndex, offsetBy: upperBound)
        return start..<end
    }
}

extension _CloseRangeProtocol {
    
    func relative<C: Collection>(to collection: C) -> Range<C.Index> where C.IndexDistance == Bound {
        let start = collection.index(collection.startIndex, offsetBy: lowerBound)
        let end = collection.index(collection.startIndex, offsetBy: upperBound + 1)
        return start..<end
    }
}

extension Range : _RangeProtocol {}

extension ClosedRange : _CloseRangeProtocol {}

extension CountableRange : _RangeProtocol {}

extension CountableClosedRange : _CloseRangeProtocol {}

extension NSRange : _RangeProtocol {
    
    typealias Bound = Int
    
    var lowerBound: Int { return location }
    
    var upperBound: Int { return NSMaxRange(self) }
    
    init(uncheckedBounds bounds: (lower: Bound, upper: Bound)) {
        self.init(Range(uncheckedBounds: bounds))
    }
    
    var isEmpty: Bool {
        return length == 0
    }
    
    func contains(_ bound: Int) -> Bool {
        return NSLocationInRange(bound, self)
    }
    
    func relative<C>(to collection: C) -> Range<C.Index> where C : Collection, C.IndexDistance == _NSRange.Bound {
        
        if let range = self.toRange() {
            return range.relative(to: collection)
        } else {
            return collection.startIndex..<collection.startIndex
        }
    }
}


extension _RangeProtocol where Bound: Strideable {
    
    var length: Bound.Stride {
        get {
            return lowerBound.distance(to: upperBound)
        }
        set {
            self = Self.init(uncheckedBounds: (lower: lowerBound, upper: lowerBound.advanced(by: max(newValue, 0) )))
        }
    }
    
    var location: Bound {
        get {
            return lowerBound
        }
        set {
            self = Self.init(uncheckedBounds: (lower: newValue, upper: newValue.advanced(by: length)))
        }
    }
}

extension _RangeProtocol {
    
    var start: Bound {
        get {
            return lowerBound
        }
        set {
            self = Self.init(uncheckedBounds: (lower: newValue, upper: upperBound))
        }
    }
    
    var end: Bound {
        get {
            return upperBound
        }
        set {
            self = Self.init(uncheckedBounds: (lower: lowerBound, upper: newValue))
        }
    }
}

extension NSRange : Equatable {

    public static func ==(lhs: NSRange, rhs: NSRange) -> Bool {
        return NSEqualRanges(lhs, rhs)
    }
}
