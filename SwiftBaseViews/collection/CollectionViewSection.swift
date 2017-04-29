//
//  CollectionSection.swift
//  TestApplication
//
//  Created by Hai Pham on 4/25/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import UIKit

/// Implement this protocol to provide section information.
public protocol CollectionSectionType {
    
    /// Since we are not using Hashable for this protocol, we can use String
    /// values as keys.
    var identifier: String { get }
    
    /// The headerTitle UILabel will display this String value.
    var header: String { get }
    
    /// Builder class type for dynamic construction of builders during
    /// view building phase.
    var viewBuilderType: CollectionHeaderBuilderType.Type? { get }
    
    /// Configuration class type for dynamic construction of configuration
    /// classes during config phase.
    var viewConfigType: CollectionHeaderConfigType.Type? { get }
    
    /// Decorator for header view.
    var decorator: CollectionHeaderDecoratorType { get }
}

public extension CollectionSectionType {

    /// Get a view builder class for dynamic building.
    ///
    /// - Returns: An InputViewHeaderBuilderType instance.
    public func viewBuilder() -> CollectionHeaderBuilderType {
        let type = (viewBuilderType ?? CollectionHeaderBuilder.self)
        return type.init(with: self)
    }
    
    /// Get a view config class for configuration.
    ///
    /// - Returns: An InputViewHeaderConfigType instance.
    public func viewConfig() -> CollectionHeaderConfigType {
        let type = (viewConfigType ?? CollectionHeaderBuilderConfig.self)
        return type.init(with: self.decorator)
    }
}

/// Implement this protocol to provide an object that contains both the
/// section and the data information. In its base state, offer only the
/// section object.
public protocol CollectionSectionHolderType {
    
    /// Get the associated CollectionSectionType.
    var section: CollectionSectionType { get }
}

/// Each instance of this class represents a section for
/// UIAdapterInputListView. We can extend it to provide custom implementations
/// for different data structures.
public class CollectionSectionHolder {
    public let section: CollectionSectionType
    
    public init(with section: CollectionSectionType) {
        self.section = section
    }
    
    /// BaseBuilder class for CollectionSectionHolder.
    public class BaseBuilder {
        fileprivate var section: CollectionSectionHolder
        
        
        /// Initialize the current Builder with a custom CollectionSectionHolder
        /// instance.
        ///
        /// - Parameter instance: A CollectionSectionHolder instance.
        public init(with instance: CollectionSectionHolder) {
            self.section = instance
        }
        
        public func build() -> CollectionSectionHolder {
            return section
        }
    }
}

extension CollectionSectionHolder: CustomComparisonType {
    public func equals(object: CollectionSectionHolder?) -> Bool {
        return section.identifier == object?.section.identifier
    }
}

extension CollectionSectionHolder: CollectionSectionHolderType {}
