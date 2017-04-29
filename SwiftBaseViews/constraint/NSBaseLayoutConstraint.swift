//
//  BaseLayoutConstraint.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/19/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import SwiftUtilities
import UIKit

/// This class shall use size representation enums for common sizes/spaces.
open class NSBaseLayoutConstraint: NSLayoutConstraint {
    
    /// By the time this variable is set, constant should have been set.
    @IBInspectable public var constantValue: String? {
        didSet {
            resetConstraint()
        }
    }
    
    /// Reset constant value based on the dynamic constantValue property,
    /// as set in InterfaceBuilder.
    fileprivate func resetConstraint() {
        guard
            let constantValue = Int(self.constantValue ?? ""),
            let representation = sizeRepresentationType,
            let sizeInstance = representation.from(value: constantValue)
        else {
            debugPrint(self)
            debugException()
            return
        }
        
        if let newConstant = sizeInstance.value {
            constant = (constant < 0 ? -1 : 1) * newConstant
        }
    }
}
