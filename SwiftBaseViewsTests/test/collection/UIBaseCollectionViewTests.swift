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
import SwiftUtilitiesTests
import UIKit
import XCTest
@testable import SwiftBaseViews

class UIBaseCollectionViewTests: XCTestCase {
    fileprivate let expectationTimeout: TimeInterval = 5
    fileprivate var collectionView: UITestCollectionView!
    fileprivate var decorator: Decorator!
    fileprivate var disposeBag: DisposeBag!
    fileprivate var presenter: Presenter!
    fileprivate var scheduler: TestScheduler!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        decorator = Decorator()
        disposeBag = DisposeBag()
        
        collectionView = UITestCollectionView(
            frame: CGRect.zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        
        presenter = Presenter(view: collectionView)
    }
    
    func test_onDecoratorSet_shouldTriggerReload() {
        // Setup
        
        // When
        collectionView.decorator = decorator
        
        // Then
        XCTAssertTrue(presenter.fake_reloadData.methodCalled)
    }
}

fileprivate class UITestCollectionView: UIBaseCollectionView {
    override var presenterInstance: UIBaseCollectionView.CollectionPresenter? {
        return presenter
    }
    
    lazy var presenter: Presenter = Presenter(view: self)
}

fileprivate class Presenter: UIBaseCollectionView.CollectionPresenter {
    let fake_reloadData = FakeDetails.builder().build()
    
    init(view: UIBaseCollectionView) {
        super.init(view: view)
    }
    
    override func reloadData(for view: UICollectionView?) {
        fake_reloadData.onMethodCalled(withParameters: view)
        super.reloadData(for: view)
    }
}

fileprivate class Decorator: CollectionViewDecoratorType {}
