//
//  CollectionHeaderIdentifier.swift
//  SwiftInputListView
//
//  Created by Hai Pham on 4/25/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// Implement this protocol to access view accessibilityIdenfitier.
public protocol CollectionHeaderIdentifierType {}

public extension CollectionHeaderIdentifierType {
    
    /// Accessibility identifier for header title.
    public var headerTitleId: String { return "headerTitle" }
}
