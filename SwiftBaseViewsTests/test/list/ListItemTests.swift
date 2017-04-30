//
//  ListItemTests.swift
//  SwiftBaseViews
//
//  Created by Hai Pham on 4/30/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import XCTest
@testable import SwiftBaseViews

class ListItemTests: XCTestCase {
    func test_createItemHolders_shouldWork() {
        // Setup
        let items = Item1.randomItems()
        
        // When
        let holder = ListItemHolder(items: items)
        
        // Then
        XCTAssertNotNil(holder.section)
        XCTAssertEqual(holder.section?.identifier, items.first?.section?.identifier)
    }
    
    func test_createSectionHolders_shouldSucceed() {
        // Setup
        let items = Item1.randomItems()
        
        // When
        let holder = ListSectionHolder<Item1>.builder(with: Section1())
            .with(items: items)
            .build()
        
        // Then
        XCTAssertEqual(holder.items, items)
    }
}

fileprivate protocol ItemProtocol1 {}

fileprivate struct Section1 {
    fileprivate static var counter: Int = 0
    
    fileprivate let count: Int
    
    fileprivate init() {
        Section1.counter += 1
        count = Section1.counter
    }
}

fileprivate struct Item1 {
    fileprivate static var counter: Int = 0
    
    fileprivate static func randomItems() -> [Item1] {
        return Array(repeating: {_ in Item1()}, for: Int.random(1, 5))
    }
    
    fileprivate static func randomHolders() -> [ListItemHolder<Item1>] {
        return Array(repeating: {_ in
            ListItemHolder(items: self.randomItems())
        }, for: Int.random(1, 10))
    }
    
    fileprivate let section: ListSectionType?
    
    fileprivate let count: Int
    
    fileprivate init() {
        Item1.counter += 1
        count = Item1.counter
        section = Section1()
    }
}

extension Section1: CustomStringConvertible {
    var description: String { return identifier }
}

extension Section1: ListSectionType {
    var identifier: String { return "Section1 \(count)" }
    var header: String { return identifier }
    var viewBuilderType: ListHeaderBuilderType.Type? { return nil }
    var viewConfigType: ListHeaderConfigType.Type? { return nil }
    var decorator: ListHeaderDecoratorType { return HeaderDecorator() }
}

extension Item1: Hashable {
    public static func ==(lhs: Item1, rhs: Item1) -> Bool {
        return lhs.description == rhs.description
    }

    var hashValue: Int {
        return description.hashValue
    }

    
}

extension Item1: CustomStringConvertible {
    var description: String { return "Item1 \(count)" }
}

extension Item1: ItemProtocol1 {}

extension Item1: SectionableListItemType {}

fileprivate class HeaderDecorator: ListHeaderDecoratorType {}
