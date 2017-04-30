//
//  CollectionSection.swift
//  SwiftBaseViews
//
//  Created by Hai Pham on 4/25/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import UIKit

/// Implement this protocol to provide section information.
public protocol ListSectionType {
    
    /// Since we are not using Hashable for this protocol, we can use String
    /// values as keys.
    var identifier: String { get }
    
    /// The headerTitle UILabel will display this String value.
    var header: String { get }
    
    /// Builder class type for dynamic construction of builders during
    /// view building phase. Return nil to use a default type.
    var viewBuilderType: ListHeaderBuilderType.Type? { get }
    
    /// Decorator for header view.
    var decorator: ListHeaderDecoratorType { get }
}

public extension ListSectionType {
    
    /// Get a view builder class for dynamic building.
    ///
    /// - Returns: An ListHeaderBuilderType instance.
    public func viewBuilder() -> ListHeaderBuilderType {
        let type = (viewBuilderType ?? ListHeaderBuilder.self)
        return type.init(with: self)
    }
}
