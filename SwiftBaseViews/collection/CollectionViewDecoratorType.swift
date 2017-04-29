//
//  CollectionViewDecoratorType.swift
//  SwiftBaseViews
//
//  Created by Hai Pham on 4/29/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit


/// Implement this protocol to provide configurations for UICollectionView 
/// appearance.
@objc public protocol CollectionViewDecoratorType {
    
    /// This value will be used to separate consecutive cells.
    @objc optional var itemSpacing: CGFloat { get }
    
    /// This value will be used to separate consecutive sections.
    @objc optional var sectionSpacing: CGFloat { get }
    
    /// This value will be used to resize the header view.
    @objc optional var sectionHeight: CGFloat { get }
}
