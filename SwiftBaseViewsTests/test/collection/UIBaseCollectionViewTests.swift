//
//  UIBaseCollectionViewTests.swift
//  SwiftBaseViews
//
//  Created by Hai Pham on 4/29/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import SwiftUIUtilities
import SwiftUtilitiesTests
import UIKit
import XCTest
@testable import SwiftBaseViews

extension CGSize {
    var reversed: CGSize { return CGSize(width: height, height: width) }
}

class UIBaseCollectionViewTests: XCTestCase {
    fileprivate let expectationTimeout: TimeInterval = 5
    fileprivate var collectionView: UITestCollectionView!
    fileprivate var decorator: Decorator!
    fileprivate var disposeBag: DisposeBag!
    fileprivate var presenter: Presenter!
    fileprivate var scheduler: TestScheduler!
    
    var screenSize = Variable<CGSize>(CGSize.zero)
    
    var currentScreenSize: CGSize { return screenSize.value }
    
    let portraitSize = CGSize(width: 1, height: 2)
    let landscapeSize = CGSize(width: 2, height: 1)
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        decorator = Decorator()
        disposeBag = DisposeBag()
        
        collectionView = UITestCollectionView(
            frame: CGRect.zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        
        presenter = collectionView.presenter
        collectionView.baseDelegate = self
        collectionView.layoutSubviews()
    }
    
    func test_onDecoratorSet_shouldTriggerReload() {
        // Setup & When
        collectionView.decorator = decorator
        
        // Then
        XCTAssertTrue(presenter.fake_reloadData.methodCalled)
    }
    
    func test_onOrientationChanged_shouldInvalidateLayout() {
        let tries = 1000
        
        var currentSize = Bool.random() ? portraitSize : landscapeSize
        
        for _ in 0..<tries {
            // Setup & When
            screenSize.value = currentSize
            
            // Then
            currentSize = currentSize.reversed
        }
        
        XCTAssertEqual(presenter.fake_invalidateLayout.methodCount, tries)
    }
}

extension UIBaseCollectionViewTests: UIBaseCollectionViewDelegate {
    var rxScreenSize: Observable<CGSize> { return screenSize.asObservable() }
}

fileprivate class UITestCollectionView: UIBaseCollectionView {
    override var presenterInstance: BaseCollectionViewPresenter? {
        return presenter
    }
    
    lazy var presenter: Presenter = Presenter(view: self)
}

fileprivate class Presenter: BaseCollectionViewPresenter {
    let fake_reloadData = FakeDetails.builder().build()
    let fake_invalidateLayout = FakeDetails.builder().build()
    
    init(view: UIBaseCollectionView) {
        super.init(view: view)
    }
    
    override func invalidateLayout(for view: UICollectionView?) {
        fake_invalidateLayout.onMethodCalled(withParameters: view)
        super.invalidateLayout(for: view)
    }
    
    override func reloadData(for view: UICollectionView?) {
        fake_reloadData.onMethodCalled(withParameters: view)
        super.reloadData(for: view)
    }
}

fileprivate class Decorator: CollectionViewDecoratorType {}
