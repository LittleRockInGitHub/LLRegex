//
//  OptionSetAdapting.swift
//  LLRegex
//
//  Created by Rock Yang on 2017/6/22.
//  Copyright © 2017年 Rock Young. All rights reserved.
//

import Foundation


protocol OptionSetAdapting : OptionSet {
    
    associatedtype Adapted: OptionSet
    
    init(adapted options: Adapted)
    
    func toAdapted() -> Adapted
    
    static var adaptedOptions: Adapted { get }
}

extension OptionSetAdapting where RawValue == Adapted.RawValue {
    
    init(adapted options: Adapted) {
        self.init(rawValue: options.intersection(Self.adaptedOptions).rawValue)
    }
    
    func toAdapted() -> Adapted {
        return Adapted.init(rawValue: self.rawValue).intersection(Self.adaptedOptions)
    }
    
    func exclusive() -> Self {
        return self.subtracting(Self.init(adapted: Self.adaptedOptions))
    }
}
