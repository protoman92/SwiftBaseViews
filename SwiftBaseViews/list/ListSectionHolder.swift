//
//  ListSectionHolder.swift
//  SwiftBaseViews
//
//  Created by Hai Pham on 4/30/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities

/// Implement this protocol to provide an object that contains both the
/// section and the data information. In its base state, offer only the
/// section object.
public protocol ListSectionHolderType {
    associatedtype Item
    
    /// Get the associated ListSectionType.
    var section: ListSectionType { get }
    
    /// Get the associated Array of ListItemHolder.
    var items: [Item] { get }
}

/// Each instance of this class represents a section for a collection/table
/// view. We can extend it to provide custom implementations for different
/// data structures.
public struct ListSectionHolder<Item> {
    public let section: ListSectionType
    
    fileprivate var sectionItems: [Item]
    
    public init(with section: ListSectionType) {
        self.section = section
        sectionItems = []
    }
}

/// BaseBuilder class for ListSectionHolder.
public class ListSectionHolderBuilder<Element> {
    public typealias Item = Element
    
    public var sectionHolder: ListSectionHolder<Item>
    
    /// Initialize the current Builder with a ListSectionHolder instance.
    ///
    /// - Parameter section: A ListSectionHolder instance.
    public init(with holder: ListSectionHolder<Item>) {
        self.sectionHolder = holder
    }
    
    /// Initialize the current Builder with a ListSectionType instance.
    ///
    /// - Parameter section: A ListSectionType instance.
    public convenience init(with section: ListSectionType) {
        self.init(with: ListSectionHolder<Item>(with: section))
    }
    
    /// Append an Item.
    ///
    /// - Parameters holder: An Item instance.
    /// - Returns: The current Builder instance.
    public func add(item: Item) -> ListSectionHolderBuilder<Item> {
        sectionHolder.sectionItems.append(item)
        return self
    }
    
    /// Append a Sequence of Item.
    ///
    /// - Parameter items: A Sequence of Item.
    /// - Returns: The current Builder instance.
    public func add<S: Sequence>(items: S) -> ListSectionHolderBuilder<Item>
        where S.Iterator.Element == Item
    {
        sectionHolder.sectionItems.append(contentsOf: items)
        return self
    }
    
    /// Set items.
    ///
    /// - Parameter items: A Sequence of ListItemHolder.
    /// - Returns: The current Builder instance.
    public func with<S: Sequence>(items: S) -> ListSectionHolderBuilder<Item>
        where S.Iterator.Element == Item
    {
        sectionHolder.sectionItems = items.map(eq)
        return self
    }
    
    public func build() -> ListSectionHolder<Item> {
        return sectionHolder
    }
}

public extension ListSectionHolder {
    
    /// Return all items.
    public var items: [Item] { return sectionItems }
}

public extension ListSectionHolder {
    
    /// Return a ListSectionHolderBuilder instance.
    ///
    /// - Parameter section: A ListSectionType instance.
    /// - Returns: A ListSectionHolderBuilder instance.
    public static func builder(with section: ListSectionType)
        -> ListSectionHolderBuilder<Item>
    {
        return ListSectionHolderBuilder<Item>(with: section)
    }
}

extension ListSectionHolder: ListSectionHolderType {}
