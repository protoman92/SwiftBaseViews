//
//  CollectionHeaderBuilderConfig.swift
//  SwiftInputListView
//
//  Created by Hai Pham on 4/25/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import SwiftUIUtilities

/// Implement this protocol to provide configurations for collection/table 
/// view headers.
public protocol ListHeaderConfigType: ViewBuilderConfigType {
    
    /// Initialize a ListHeaderConfigType instance using a 
    /// ListHeaderDecoratorType object. The latter contains information
    /// required to configure the header view's appearance.
    ///
    /// - Parameter decorator: A ListHeaderDecoratorType instance.
    init(with decorator: ListHeaderDecoratorType)
    
    /// Use this decorator to configure collection view header appearance.
    var decorator: ListHeaderDecoratorType { get }
}

/// Builder configuration class for collection/table view header.
open class ListHeaderBuilderConfig {
    public let decorator: ListHeaderDecoratorType
    
    public required init(with decorator: ListHeaderDecoratorType) {
        self.decorator = decorator
    }
    
    open func configure(for view: UIView) {
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

extension ListHeaderBuilderConfig: ListHeaderConfigType {}
extension ListHeaderBuilderConfig: ListHeaderIdentifierType {}

extension ListHeaderBuilderConfig: ListHeaderDecoratorType {
    public var headerTitleTextColor: UIColor {
        return decorator.headerTitleTextColor ?? .darkGray
    }
    
    public var backgroundColor: UIColor {
        return decorator.backgroundColor ?? .clear
    }
}
