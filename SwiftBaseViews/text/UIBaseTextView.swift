//
//  UIBaseTextView.swift
//  SwiftBaseViews
//
//  Created by Hai Pham on 4/29/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import UIKit

open class UIBaseTextView: UITextView {
    
    /// These value will be set via InterfaceBuilder.
    @IBInspectable public var fontName: String?
    @IBInspectable public var fontSize: String?
    
    /// Use this variable to set font only once. We should not use
    /// awakeFromNib() since it will not be called if we construct an instance
    /// dynamically.
    fileprivate var initialized = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        guard !initialized else {
            return
        }
        
        defer { initialized = true }
        setFontDynamically()
    }
}

extension UIBaseTextView: DynamicFontType {
    public var activeFont: UIFont? {
        get { return font }
        set { font = newValue }
    }
}
