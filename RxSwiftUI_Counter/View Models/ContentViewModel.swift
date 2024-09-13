//
//  ContentViewModel.swift
//  RxSwiftUI_Counter
//
//  Created by Scott Gardner on 9/13/24.
//

import RxCocoa
import RxSwift

/// The view model that manages the logic for the counter, including starting, stopping, and resetting the counter.
final class ContentViewModel {
    /// A `BehaviorRelay` that emits the current counter value, starting at 0.
    private(set) var counterRelay = BehaviorRelay<Int>(value: 0)

    /// Tracks whether the counter is currently running.
    private(set) var isRunning = false

    /// The `DisposeBag` that manages the lifecycle of the timer subscription.
    /// - NOTE: If you need to handle additional subscriptions, create a separate `DisposeBag` property to manage their
    /// lifecycle.
    private var timerDisposeBag = DisposeBag()

    /// Toggles the counter between running and stopped.
    func toggleCounter() {
        isRunning ? stopCounter() : startCounter()
    }

    /// Starts the counter by subscribing to the timer observable. The first value is emitted immediately, and then
    /// every second the counter is incremented and emitted via the `counterRelay`.
    private func startCounter() {
        isRunning = true

        // Start timer.
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                let nextValue = counterRelay.value + 1
                counterRelay.accept(nextValue) // Emit the incremented value.
            })
            .disposed(by: timerDisposeBag)
    }

    /// Stops the counter by disposing of the current timer subscription.
    private func stopCounter() {
        isRunning = false
        timerDisposeBag = DisposeBag() // Dispose of the timer subscription.
    }

    /// Resets the counter value back to 0 and emits this value via the `counterRelay`.
    func resetCounter() {
        counterRelay.accept(0) // Reset to initial value of 0.
    }
}
