//
//  UIBaseCollectionView.swift
//  SwiftBaseViews
//
//  Created by Hai Pham on 4/29/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import SwiftUIUtilities
import UIKit

/// Extend this class to enjoy preset configurations. Please note that this
/// is quite opinionated, so if customization is what you are looking for,
/// it's probably not the best choice.
open class UIBaseCollectionView: UICollectionView {
    
    /// UIBaseCollectionView subclasses must override this variable to
    /// provide their own presenter implementations.
    open var presenterInstance: BaseCollectionViewPresenter? {
        fatalError("Must override this")
    }
}

/// Base presenter class for UIBaseCollectionView.
open class BaseCollectionViewPresenter: BaseViewPresenter {
    
    /// Decorator to configure appearance.
    let decorator: Variable<CollectionViewDecoratorType?>
    
    /// Use this DisposeBag for rx-related operations.
    public let disposeBag: DisposeBag
    
    public override init<P: UIBaseCollectionView>(view: P) {
        decorator = Variable<CollectionViewDecoratorType?>(nil)
        disposeBag = DisposeBag()
        super.init(view: view)
        setupDecoratorObserver(for: view, with: self)
    }
    
    /// Stub out this method to avoid double-calling reloadData() during
    /// unit tests.
    ///
    /// - Parameters:
    ///   - view: The current UICollectionView instance.
    ///   - current: The current BaseCollectionViewPresenter instance.
    open func setupDecoratorObserver(for view: UICollectionView,
                                     with current: BaseCollectionViewPresenter) {
        decorator.asObservable()
            .doOnNext({[weak current, weak view] _ in
                current?.reloadData(for: view)
            })
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    /// Reload data for the current collection view.
    ///
    /// - Parameter view: A UICollectionView instance.
    open func reloadData(for view: UICollectionView?) {
        view?.reloadData()
    }
}

public extension UIBaseCollectionView {
    
    /// When decorator is set, pass it to the presenter.
    public var decorator: CollectionViewDecoratorType? {
        get { return presenterInstance?.decorator.value }
        set { presenterInstance?.decorator.value = newValue }
    }
}

extension BaseCollectionViewPresenter: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing = sectionSpacing
        
        // We set top and bottom insets to space out sections.
        return UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAt section: Int)
        -> CGFloat
    {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int)
        -> CGFloat
    {
        return itemSpacing
    }
}

extension BaseCollectionViewPresenter: CollectionViewDecoratorType {
    
    /// Item spacing.
    public var itemSpacing: CGFloat {
        return decorator.value?.itemSpacing ?? 0
    }
    
    /// Section spacing
    public var sectionSpacing: CGFloat {
        return decorator.value?.sectionSpacing ?? 0
    }
    
    public var sectionHeight: CGFloat {
        return decorator.value?.sectionHeight ?? 0
    }
}

