//
//  ListHeaderDecorator.swift
//  SwiftInputListView
//
//  Created by Hai Pham on 4/25/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Decorator class for collection/table section views.
@objc public protocol ListHeaderDecoratorType {
    
    /// Use a default value if this is not implemented.
    @objc optional var headerTitleFontName: String { get }
    
    /// Use a default value if this is not implemented.
    @objc optional var headerTitleFontSize: CGFloat { get }
    
    /// Text color for header title.
    @objc optional var headerTitleTextColor: UIColor { get }
    
    /// Background color for header view.
    @objc optional var backgroundColor: UIColor { get }
}

public extension ListHeaderDecoratorType {
    
    /// Get the UIFont instance that will be passed to the header title.
    public var headerTitleFont: UIFont? {
        let fontName = headerTitleFontName ?? ""
        let fontSize = headerTitleFontSize ?? 0
        return UIFont(name: fontName, size: fontSize)
    }
}
