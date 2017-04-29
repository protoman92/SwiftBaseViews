//
//  CollectionHeaderBuilderConfig.swift
//  SwiftInputListView
//
//  Created by Hai Pham on 4/25/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import SwiftUIUtilities

/// Implement this protocol to provide configurations for collection view 
/// headers.
public protocol CollectionHeaderConfigType: ViewBuilderConfigType {
    
    /// Initialize a CollectionHeaderConfigType instance using a
    /// CollectionHeaderDecoratorType object. The latter contains information
    /// required to configure the header view's appearance.
    ///
    /// - Parameter decorator: A CollectionHeaderDecoratorType instance.
    init(with decorator: CollectionHeaderDecoratorType)
    
    /// Use this decorator to configure collection view header appearance.
    var decorator: CollectionHeaderDecoratorType { get }
}

/// Builder configuration class for collection view header.
open class CollectionHeaderBuilderConfig {
    public let decorator: CollectionHeaderDecoratorType
    
    public required init(with decorator: CollectionHeaderDecoratorType) {
        self.decorator = decorator
    }
    
    public func configure(for view: UIView) {
        view.backgroundColor = backgroundColor
        
        if let headerTitle = view.subviews.filter({
            $0.accessibilityIdentifier == headerTitleId
        }).first as? UILabel {
            configure(headerTitle: headerTitle)
        }
    }
    
    /// Configure the header title label.
    ///
    /// - Parameter headerTitle: A UILabel instance.
    open func configure(headerTitle: UILabel) {
        headerTitle.textColor = headerTitleTextColor
    }
}

extension CollectionHeaderBuilderConfig: CollectionHeaderConfigType {}
extension CollectionHeaderBuilderConfig: CollectionHeaderIdentifierType {}

extension CollectionHeaderBuilderConfig: CollectionHeaderDecoratorType {
    public var headerTitleTextColor: UIColor {
        return decorator.headerTitleTextColor ?? .darkGray
    }
    
    public var backgroundColor: UIColor {
        return decorator.backgroundColor ?? .clear
    }
}
