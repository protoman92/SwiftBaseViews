//
//  ListHeaderBuilder.swift
//  SwiftInputListView
//
//  Created by Hai Pham on 4/25/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import SwiftUIUtilities

/// Implement this protocol to provide builder for collection/table view 
/// headers.
public protocol ListHeaderBuilderType: ViewBuilderType {
    
    /// Initialize a ListHeaderBuilderType using a ListSectionType intance.
    /// The latter contains information required to populate the headers' 
    /// subviews, such as header title.
    ///
    /// - Parameter section: A ListSectionType instance.
    init(with section: ListSectionType)
    
    /// Get the associated list view section.
    var section: ListSectionType { get }
    
    /// Use this decorator to configure collection view header appearance.
    var decorator: ListHeaderDecoratorType { get }
}

/// Builder class for collection/table view header views. This is the default 
/// class to be used whenever a ListHeaderBuilderType instance is required.
open class ListHeaderBuilder {
    public let section: ListSectionType
    public let decorator: ListHeaderDecoratorType
    
    public required init(with section: ListSectionType) {
        self.section = section
        self.decorator = section.decorator
    }
}

extension ListHeaderBuilder {
    open func builderComponents(for view: UIView) -> [ViewBuilderComponentType] {
        let section = self.section
        let headerTitle = self.headerTitle(for: view, using: section)
        return [headerTitle]
    }
    
    /// Header title for each section.
    ///
    /// - Parameters:
    ///   - view: The master UIView.
    ///   - section: An ListSectionType instance.
    /// - Returns: A ViewBuilderComponentType instance.
    open func headerTitle(for view: UIView, using section: ListSectionType)
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

extension ListHeaderBuilder {
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

extension ListHeaderBuilder: ListHeaderDecoratorType {
    public var headerTitleTextColor: UIColor {
        return decorator.headerTitleTextColor ?? .darkGray
    }
    
    public var backgroundColor: UIColor {
        return decorator.backgroundColor ?? .clear
    }
}

extension ListHeaderBuilder: ListHeaderIdentifierType {}
extension ListHeaderBuilder: ListHeaderBuilderType {}
