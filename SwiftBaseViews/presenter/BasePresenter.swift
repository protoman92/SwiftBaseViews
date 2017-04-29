//
//  BasePresenter.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/18/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import UIKit

/// Implement this protocol to provide a presenter-like interface to interact
/// with views and view controllers.
@objc public protocol PresenterType: class {
    var viewDelegate: PresenterDelegate? { get }
}

/// We use Presenters to abstract away View interactions. Since Presenters
/// can be inherited from/subclassed, we have more leeway with regards to
/// DRY.
@objc open class BasePresenter: NSObject {
    fileprivate weak var view: PresenterDelegate?
    
    /// Return view instance.
    open var viewDelegate: PresenterDelegate? {
        return view
    }
    
    /// Return the view presented by this presenter.
    open var presentedView: UIView? {
        fatalError("Must override this variable")
    }
    
    public init<P: PresenterDelegate>(view: P) {
        self.view = view
    }
}

extension BasePresenter: ActionSelectorType {
    open func actionReceived(sender: AnyObject, event: UIEvent) {
        actionExecuted(sender: sender, event: event)
    }
    
    open func actionExecuted(sender: AnyObject, event: UIEvent) {
        fatalError()
    }
}

extension BasePresenter: PresenterType {}

/// UIViewController/UIView instances should implement this protocol to have
/// their views handled by the respective presenters.
@objc public protocol PresenterDelegate: class {}
