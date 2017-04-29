//
//  UIBaseViewController.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Basic view controller class that uses a ViewControllerPresenterType
/// instance for controller-specific methods.
open class UIBaseViewController: UIViewController {
    
    /// Override this variable to provide custom presenters.
    open var presenterInstance: ViewControllerPresenterType? {
        fatalError("Must override this")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        presenterInstance?.viewDidLoad(for: self)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenterInstance?.viewWillAppear(for: self, animated: animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenterInstance?.viewDidAppear(for: self, animated: animated)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenterInstance?.viewWillDisappear(for: self, animated: animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenterInstance?.viewDidDisappear(for: self, animated: animated)
    }
    
    /// This method is called when app orientation changes.
    ///
    /// - Parameters:
    ///   - size: The new size in CGSize.
    ///   - coordinator: A UIViewControllerTransitionCoordinator instance.
    override open func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        presenterInstance?.viewWillTransition(to: size, with: coordinator, for: self)
    }
}
