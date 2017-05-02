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
    
    /// Call the presenter's layoutSubview(for:) method.
    override open func layoutSubviews() {
        super.layoutSubviews()
        presenterInstance?.layoutSubviews(for: self)
    }
}

/// Base presenter class for UIBaseCollectionView.
open class BaseCollectionViewPresenter: BaseViewPresenter {
    
    /// Set this to true after layoutSubviews() has been called for the first
    /// time.
    fileprivate lazy var initialized = false
    
    /// Return the current CollectionViewDecoratorType instance.
    public var decorator: CollectionViewDecoratorType? {
        return rxDecorator.value
    }
    
    /// Decorator to configure appearance.
    let rxDecorator: Variable<CollectionViewDecoratorType?>
    
    /// Use this DisposeBag for rx-related operations.
    public let disposeBag: DisposeBag
    
    public override init<P: UIBaseCollectionView>(view: P) {
        rxDecorator = Variable<CollectionViewDecoratorType?>(nil)
        disposeBag = DisposeBag()
        super.init(view: view)
    }
    
    override open func layoutSubviews(for view: UIView) {
        super.layoutSubviews(for: view)
        
        guard !initialized, let view = view as? UICollectionView else {
            return
        }
        
        defer { initialized = true }
        
        setupDecoratorObserver(for: view, with: self)
        
        // We need to set the delegate here, or else when the cells are
        // dequeued they may have wrong dimensions. Worse case scenario, they
        // may even be dequeued at all.
        view.delegate = self
    }
    
    /// Stub out this method to avoid double-calling reloadData() during
    /// unit tests.
    ///
    /// - Parameters:
    ///   - view: The current UICollectionView instance.
    ///   - current: The current BaseCollectionViewPresenter instance.
    open func setupDecoratorObserver(for view: UICollectionView,
                                     with current: BaseCollectionViewPresenter) {
        rxDecorator.asObservable()
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

extension UIBaseCollectionView {
    
    /// When decorator is set, pass it to the presenter.
    open var decorator: CollectionViewDecoratorType? {
        get { return presenterInstance?.rxDecorator.value }
        set { presenterInstance?.rxDecorator.value = newValue }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BaseCollectionViewPresenter: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
        let spacing = sectionSpacing
        
        // We set top and bottom insets to space out sections.
        return UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int)
        -> CGFloat
    {
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int)
        -> CGFloat
    {
        return itemSpacing
    }
    
    /// Override this function to provide custom size. The implementation
    /// below represents the setup that is most commonly used.
    ///
    /// - Parameters:
    ///   - collectionView: The current UICollectionView instance.
    ///   - collectionViewLayout: A UICollectionViewLayout instance.
    ///   - indexPath: An IndexPath instance.
    /// - Returns: A CGSize instance.
    open func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: itemHeight)
    }
}

extension BaseCollectionViewPresenter: CollectionViewDecoratorType {
    
    /// Item spacing.
    open var itemSpacing: CGFloat {
        return decorator?.itemSpacing ?? 0
    }
    
    /// Section spacing
    open var sectionSpacing: CGFloat {
        return decorator?.sectionSpacing ?? 0
    }
    
    open var sectionHeight: CGFloat {
        return decorator?.sectionHeight ?? 0
    }
    
    open var itemHeight: CGFloat {
        return decorator?.itemHeight ?? 0
    }
}

