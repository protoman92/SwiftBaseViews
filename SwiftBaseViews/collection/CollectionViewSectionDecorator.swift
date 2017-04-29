//
//  CollectionSectionDecorator.swift
//  SwiftInputListView
//
//  Created by Hai Pham on 4/25/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Decorator class for collection section views.
@objc public protocol CollectionHeaderDecoratorType {
    
    /// Text color for header title.
    @objc optional var headerTitleTextColor: UIColor { get }
    
    /// Background color for header view.
    @objc optional var backgroundColor: UIColor { get }
}
