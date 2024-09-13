//
//  ViewModel.swift
//  RxSwiftUI_Counter
//
//  Created by Scott Gardner on 9/13/24.
//

import RxCocoa
import RxSwift

/// Manages the logic for the counter, including starting, stopping, and resetting it.
final class ViewModel {

    /// A `BehaviorRelay` that emits the current counter value, starting at 0.
    private(set) var counterRelay = BehaviorRelay<Int>(value: 0)

    /// Tracks whether the counter is currently running.
    private(set) var isRunning = false

    /// Holds the reference to the current timer subscription.
    private var timerSubscription: Disposable?

    /// Starts the counter by subscribing to a timer observable that emits every second. The counter increments by 1
    /// each second, and the new value is emitted via `counterRelay`.
    func startCounter() {
        guard !isRunning else { return }
        isRunning = true

        // Start timer and store the subscription reference.
        timerSubscription = Observable<Int>.timer(
            .seconds(0),
            period: .seconds(1),
            scheduler: MainScheduler.instance
        )
        .subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            let nextValue = counterRelay.value + 1
            counterRelay.accept(nextValue)
        })

        // Add the subscription to the shared `SubscriptionsManager`.
        SubscriptionsManager.shared.add(timerSubscription!)
    }

    /// Stops the counter by disposing of the current timer subscription. It also resets the `SubscriptionsManager` and
    /// marks the counter as not running.
    func stopCounter() {
        isRunning = false

        // Dispose of the current timer subscription.
        timerSubscription?.dispose()
        timerSubscription = nil

        // Reset the `SubscriptionsManager` to clean up any active subscriptions.
        SubscriptionsManager.shared.reset()
    }

    /// Resets the counter value back to 0 and emits this value via the `counterRelay`.
    func resetCounter() {
        counterRelay.accept(0)
    }

    /// Toggles the counter between running and stopped states. If the counter is running, it will stop. If it is
    /// stopped, it will start.
    func toggleCounter() {
        isRunning ? stopCounter() : startCounter()
    }
}
