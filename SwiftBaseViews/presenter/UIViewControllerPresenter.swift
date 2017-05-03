//
//  UIViewControllerPresenter.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import SwiftUIUtilities
import SwiftUtilities
import UIKit

/// Implement this protocol to provide presenter interface for view controllers.
@objc public protocol ViewControllerPresenterType: PresenterType {
    /// This is called when the controller calls viewDidLoad().
    ///
    /// - Parameter controller: The current UIViewController instance.
    func viewDidLoad(for controller: UIViewController)
    
    /// This is called when the controller calls  viewWillAppear(animated:).
    ///
    /// - Parameters:
    ///   - controller: The current UIViewController instance.
    ///   - animated: A Bool value.
    func viewWillAppear(for controller: UIViewController, animated: Bool)
    
    /// This is called when the controller calls viewDidAppear(animated:).
    ///
    /// - Parameters:
    ///   - controller: The current UIViewController instance.
    ///   - animated: A Bool value.
    func viewDidAppear(for controller: UIViewController, animated: Bool)
    
    
    /// This is called when the controller calls viewWillDisappear(animated:)
    ///
    /// - Parameters:
    ///   - controller: The current UIViewController instance.
    ///   - animated: A Bool value.
    func viewWillDisappear(for controller: UIViewController, animated: Bool)
    
    /// This is called when the controller calls viewDidDisappear(animated:).
    ///
    /// - Parameters:
    ///   - controller: The current UIViewController instance.
    ///   - animated: A Bool value.
    func viewDidDisappear(for controller: UIViewController, animated: Bool)
    
    /// This is called when the controller calls viewWillTransition(to:with:).
    ///
    /// - Parameters:
    ///   - size: The current screen size.
    ///   - coordinator: A UIViewControllerTransitionCoordinator instance.
    ///   - controller: The current UIViewController instance.
    func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator,
        for controller: UIViewController
    )
}

/// This Presenter class is used for UIViewController. It contains methods
/// such as viewDidLoad, viewDidAppear etc. so that the owner view controller
/// can delegate to.
@objc open class BaseViewControllerPresenter: BasePresenter {
    override open var presentedView: UIView? {
        return viewController?.view
    }
    
    /// Get the current viewController. Throw an error if it is not available.
    public var viewController: UIViewController? {
        guard let controller = viewDelegate as? UIViewController else {
            debugException()
            return nil
        }

        return controller
    }
    
    /// Use this DisposeBag instance for rx-related operations.
    public let disposeBag = DisposeBag()
    
    /// When orientation size changes, this value will be updated.
    fileprivate var screenSize = Variable<CGSize>(CGSize.zero)
    
    public override init<P: UIViewController>(view: P) {
        super.init(view: view)
    }
    
    open func viewDidLoad(for controller: UIViewController) {
        screenSize.value = UIScreen.main.bounds.size
        
        screenSize.asObservable().skip(1)
            .doOnNext({[weak self] in
                self?.screenSizeDidChange(to: $0, with: self)
            })
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    open func viewWillAppear(for controller: UIViewController, animated: Bool) {}
    
    open func viewDidAppear(for controller: UIViewController, animated: Bool) {}
    
    open func viewWillDisappear(for controller: UIViewController, animated: Bool) {}
    
    open func viewDidDisappear(for controller: UIViewController, animated: Bool) {}
    
    open func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator,
        for controller: UIViewController)
    {
        screenSize.value = size
    }
    
    /// This method is called when the screen size changes i.e. when the
    /// app changes orientation.
    ///
    /// - Parameters:
    ///   - size: The new screen size. A CGSize instance.
    ///   - current: The current BaseViewControllerPresenter instance.
    open func screenSizeDidChange(
        to size: CGSize,
        with current: BaseViewControllerPresenter?
    ) {}
}

public extension BaseViewControllerPresenter {
    
    /// Return screenSize as part of OrientationDetectorType conformance.
    public var currentScreenSize: CGSize {
        return screenSize.value
    }
    
    /// Subscribe to this Observable to receive screen size notifications.
    public var rxScreenSize: Observable<CGSize> {
        return screenSize.asObservable()
    }
    
    /// Subscribe to this Observable to receive orientation notifications.
    public var rxScreenOrientation: Observable<BasicOrientation> {
        return rxScreenSize.map(BasicOrientation.init)
    }
}

extension BaseViewControllerPresenter {
    
    /// Present a UIViewController.
    ///
    /// - Parameters:
    ///   - controller: The UIViewController instance to be presented.
    ///   - animated: A Bool value.
    ///   - completion: An optional completion closure.
    open func presentController(_ controller: UIViewController,
                                animated: Bool,
                                completion: (() -> Void)?) {
        viewController?.presentController(controller,
                                          animated: animated,
                                          completion: completion)
    }
}

extension BaseViewControllerPresenter: ViewControllerPresenterType {}
extension BaseViewControllerPresenter: OrientationDetectorType {}
extension BaseViewControllerPresenter: ControllerPresentableType {}
extension UIViewController: PresenterDelegate {}
