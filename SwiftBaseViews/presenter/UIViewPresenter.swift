//
//  UIViewPresenter.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

@objc public protocol ViewPresenterType: PresenterType {
    /// This method should be called when the UIView's constructor is called.
    ///
    /// - Parameter view: The UIView handled by the current Presenter.
    func onViewInit(for view: UIView)
    
    /// This method should be called when the UIView's awakeFromNib() method
    /// is called. Note that this method may not be called if the UIView is
    /// not constructed from a Nib.
    ///
    /// - Parameter view: The UIView handled by the current Presenter.
    func awakeFromNib(for view: UIView)
    
    /// This method should be called when the UIView's layoutSubviews() method
    /// is called.
    ///
    /// - Parameter view: The UIView handled by the current Presenter.
    func layoutSubviews(for view: UIView)
    
    /// This method should be called the UIView's remoteFromSuperview() method
    /// is called.
    ///
    /// - Parameter view: The UIView handled by the current Presenter.
    func removeFromSuperview(for view: UIView)
}

/// This Presenter should be used for UIView subclasses. Since there are
/// many different subclasses, each Presenter instance needs to reimplement
/// the methods outlined below, and its UIView needs to explicitly call them
/// where appropriate.
@objc open class BaseViewPresenter: BasePresenter {
    override open var presentedView: UIView? {
        return viewDelegate as? UIView
    }
    
    public override init<P: UIView>(view: P) {
        super.init(view: view)
    }
    
    open func onViewInit(for view: UIView) {}
    
    open func awakeFromNib(for view: UIView) {}
    
    open func layoutSubviews(for view: UIView) {}
    
    open func removeFromSuperview(for view: UIView) {}
}

extension BaseViewPresenter: ViewPresenterType {}

extension UIView: PresenterDelegate {}
