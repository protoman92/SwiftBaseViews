//
//  SectionableListItem.swift
//  SwiftBaseViews
//
//  Created by Hai Pham on 4/30/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import UIKit

/// Implement this protocol to provide collection/table view items that can be
/// sectioned.
public protocol SectionableListItemType {
    
    /// Get the section to which this item belongs.
    var section: ListSectionType? { get }
}

public extension ListItemHolderType where Item: SectionableListItemType {
    
    /// Get the associated section for all SectionableListItemType instances. 
    /// If there are different sections among the items, take only the first 
    /// one i.e. we are assuming all items share the same section (as it should 
    /// be).
    public var section: ListSectionType? {
        return items.first?.section
    }
}
