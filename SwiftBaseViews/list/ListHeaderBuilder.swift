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

    // MARK: ViewBuilderType
    
    /// Get an Array of UIView subviews to be added to a UIView.
    /// - Parameter view: The parent UIView instance.
    /// - Returns: An Array of ViewBuilderComponentType.
    open func subviews(for view: UIView) -> [UIView] {
        return [headerTitle()]
    }
    
    /// Get a UILabel to act as the header title.
    ///
    /// - Returns: A UILabel instance.
    open func headerTitle() -> UILabel {
        let label = UILabel()
        label.accessibilityIdentifier = headerTitleId
        return label
    }
    
    /// Get an Array of NSLayoutConstraint to be added to a UIView.
    ///
    /// - Parameter view: The parent UIView instance.
    /// - Returns: An Array of NSLayoutConstraint.
    open func constraints(for view: UIView) -> [NSLayoutConstraint] {
        var allConstraints = [NSLayoutConstraint]()
        let subviews = view.subviews
        
        if let label = subviews.filter({
            $0.accessibilityIdentifier == headerTitleId
        }).first as? UILabel {
            let constraints = self.constraints(forHeaderTitle: label, for: view)
            allConstraints.append(contentsOf: constraints)
        }
        
        return allConstraints
    }
    
    /// Get an Array of NSLayoutConstraint for the header title label to be 
    /// added to the parent UIView.
    ///
    /// - Parameters:
    ///   - label: An optional UILabel instance.
    ///   - view: The parent UIView
    /// - Returns: An Array of NSLayoutConstraint.
    open func constraints(forHeaderTitle label: UILabel, for view: UIView)
        -> [NSLayoutConstraint]
    {
        return FitConstraintSet.builder()
            .with(parent: view)
            .with(child: label)
            .add(left: true, withMargin: Space.small.value)
            .add(right: true)
            .add(top: true)
            .add(bottom: true)
            .build()
            .constraints
    }
}

extension ListHeaderBuilder {
    open func configure(for view: UIView) {
        let section = self.section
        
        view.backgroundColor = backgroundColor
        
        if let headerTitle = view.subviews.filter({
            $0.accessibilityIdentifier == headerTitleId
        }).first as? UILabel {
            configure(headerTitle: headerTitle, using: section, using: self)
        }
    }
    
    /// Configure the header title label.
    ///
    /// - Parameters:
    ///   - headerTitle: A UILabel instance.
    ///   - section: A ListSectionType instance.
    ///   - decorator: A ListHeaderDecoratorType instance.
    open func configure(headerTitle: UILabel,
                        using section: ListSectionType,
                        using decorator: ListHeaderDecoratorType) {
        headerTitle.textColor = headerTitleTextColor
        headerTitle.font = headerTitleFont
        headerTitle.text = section.header
    }
}

extension ListHeaderBuilder: ListHeaderDecoratorType {
    public var headerTitleFontName: String {
        return decorator.headerTitleFontName ?? DefaultFont.normal.value
    }
    
    public var headerTitleFontSize: CGFloat {
        return decorator.headerTitleFontSize ?? TextSize.medium.value ?? 0
    }
    
    public var headerTitleTextColor: UIColor {
        return decorator.headerTitleTextColor ?? .darkGray
    }
    
    public var backgroundColor: UIColor {
        return decorator.backgroundColor ?? .clear
    }
}

extension ListHeaderBuilder: ListHeaderIdentifierType {}
extension ListHeaderBuilder: ListHeaderBuilderType {}
