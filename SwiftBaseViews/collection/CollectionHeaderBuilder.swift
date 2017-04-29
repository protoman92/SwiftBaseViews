//
//  CollectionHeaderBuilder.swift
//  SwiftInputListView
//
//  Created by Hai Pham on 4/25/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import SwiftUIUtilities

/// Implement this protocol to provide builder for collection view headers.
public protocol CollectionHeaderBuilderType: ViewBuilderType {
    
    /// Initialize a CollectionHeaderBuilderType using a CollectionSectionType
    /// intance. The latter contains information required to populate the
    /// headers' subviews, such as header title.
    ///
    /// - Parameter section: A CollectionSectionType instance.
    init(with section: CollectionSectionType)
    
    /// Get the associated collection view section.
    var section: CollectionSectionType { get }
}

/// Builder class for collection view header views. This is the default class
/// to be used whenever a CollectionHeaderBuilderType instance is required.
open class CollectionHeaderBuilder {
    public let section: CollectionSectionType
    
    public required init(with section: CollectionSectionType) {
        self.section = section
    }
    
    open func builderComponents(for view: UIView) -> [ViewBuilderComponentType] {
        let section = self.section
        let headerTitle = self.headerTitle(for: view, using: section)
        return [headerTitle]
    }
    
    /// Header title for each section.
    ///
    /// - Parameters:
    ///   - view: The master UIView.
    ///   - section: An CollectionSectionType instance.
    /// - Returns: A ViewBuilderComponentType instance.
    open func headerTitle(for view: UIView, using section: CollectionSectionType)
        -> ViewBuilderComponentType
    {
        let label = UIBaseLabel()
        label.fontName = String(describing: 1)
        label.fontSize = String(describing: 5)
        label.accessibilityIdentifier = headerTitleId
        label.text = section.header
        
        let constraints = FitConstraintSet.builder()
            .with(parent: view)
            .with(child: label)
            .add(left: true, withMargin: Space.small.value)
            .add(right: true)
            .add(top: true)
            .add(bottom: true)
            .build()
            .constraints
        
        return ViewBuilderComponent.builder()
            .with(view: label)
            .with(constraints: constraints)
            .build()
    }
}

extension CollectionHeaderBuilder: CollectionHeaderIdentifierType {}
extension CollectionHeaderBuilder: CollectionHeaderBuilderType {}
