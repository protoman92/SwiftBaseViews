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
    open func builderComponents() -> [ViewBuilderComponentType] {
        let section = self.section
        let headerTitle = self.headerTitle(using: section)
        return [headerTitle]
    }
    
    /// Get a UILabel to act as the header title.
    ///
    /// - Returns: A UILabel instance.
    open func headerTitle() -> UILabel { return UILabel() }
    
    /// Get an Array of NSLayoutConstraint to be added to the parent UIView.
    /// This function will be called within a closure, so the label needs
    /// to be optional to avoid leaks.
    ///
    /// - Parameters:
    ///   - view: The parent UIView
    ///   - label: An optional UILabel instance.
    /// - Returns: An Array of NSLayoutConstraint.
    open func headerTitleConstraints(for view: UIView, for label: UILabel?)
        -> [NSLayoutConstraint]
    {
        guard let label = label else { return [] }
        
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
    
    /// Header title for each section.
    ///
    /// - Parameters section: An ListSectionType instance.
    /// - Returns: A ViewBuilderComponentType instance.
    open func headerTitle(using section: ListSectionType)
        -> ViewBuilderComponentType
    {
        let label = headerTitle()

        label.accessibilityIdentifier = headerTitleId
        
        let closure: (UIView) -> [NSLayoutConstraint] = {
            [weak self, weak label] in
            return self?.headerTitleConstraints(for: $0, for: label) ?? []
        }
        
        return ViewBuilderComponent.builder()
            .with(view: label)
            .with(closure: closure)
            .build()
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
