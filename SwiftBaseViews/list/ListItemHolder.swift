//
//  ListItemHolder.swift
//  SwiftBaseViews
//
//  Created by Hai Pham on 4/30/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities

/// Implement this protocol to hold an Array of items for a collection/table 
/// view.
public protocol ListItemHolderType {
    associatedtype Item
    
    var items: [Item] { get }
}

/// Use this struct to carry Item instances, instead of having an Array of 
/// Item objects.
public struct ListItemHolder<Element> {
    public typealias Item = Element
    
    var allItems: [Element]
    
    init(items: [Element]) { allItems = items }
    
    init() { self.init(items: []) }
}

/// Builder class for ListItemHolder.
public final class ListItemHolderBuilder<Element> {
    public var holder: ListItemHolder<Element>
    
    public init() {
        holder = ListItemHolder<Element>()
    }
    
    /// Add a Element instance.
    ///
    /// - Parameter input: A Element instance.
    /// - Returns: The current Builder instance.
    public func add(input: Element) -> ListItemHolderBuilder<Element> {
        holder.allItems.append(input)
        return self
    }
    
    /// Set allItems.
    ///
    /// - Parameter items: A sequence of Element.
    /// - Returns: The current Builder instance.
    public func with<S: Sequence>(items: S) -> ListItemHolderBuilder<Element>
        where S.Iterator.Element == Element
    {
        holder.allItems = items.map(eq)
        return self
    }
    
    /// Set allItems.
    ///
    /// - Parameter items: A sequence of Any.
    /// - Returns: The current Builder instance.
    public func with<S: Sequence>(items: S) -> ListItemHolderBuilder<Element>
        where S.Iterator.Element: Any
    {
        holder.allItems = items.flatMap({$0 as? Element})
        return self
    }
    
    public func build() -> ListItemHolder<Element> {
        return holder
    }
}

extension ListItemHolder: Collection {
    public var startIndex: Int {
        return allItems.startIndex
    }
    
    public var endIndex: Int {
        return allItems.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return Swift.min(i + 1, endIndex)
    }
    
    public subscript(index: Int) -> Element {
        return allItems[index]
    }
}

public extension ListItemHolder {
    
    /// Return all items.
    public var items: [Element] { return allItems }
}

extension ListItemHolder: ListItemHolderType {}
