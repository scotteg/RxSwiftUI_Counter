//
//  SubscriptionsManager.swift
//  RxSwiftUI_Counter
//
//  Created by Scott Gardner on 9/13/24.
//

import RxSwift

/// A singleton manager that handles all subscriptions.
final class SubscriptionsManager {
    static let shared = SubscriptionsManager()

    /// A central `DisposeBag` that manages all subscriptions added to it.
    private(set) var disposeBag = DisposeBag()

    private init() {}

    /// Add a disposable to the global dispose bag.
    func add(_ disposable: Disposable) {
        disposable.disposed(by: disposeBag)
    }

    /// Resets the `DisposeBag`, which clears all active subscriptions.
    func reset() {
        disposeBag = DisposeBag()
    }
}
