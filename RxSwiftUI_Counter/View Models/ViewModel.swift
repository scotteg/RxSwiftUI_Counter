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
    private(set) var counterRelay = BehaviorRelay<Int>(value: 0)
    private(set) var isRunning = false
    private var timerSubscription: Disposable?

    func startCounter() {
        guard !isRunning else { return }
        isRunning = true

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

        SubscriptionsManager.shared.add(timerSubscription!)
    }

    func stopCounter() {
        isRunning = false
        timerSubscription?.dispose()
        timerSubscription = nil
        SubscriptionsManager.shared.reset()
    }

    func resetCounter() {
        counterRelay.accept(0)
    }

    func toggleCounter() {
        isRunning ? stopCounter() : startCounter()
    }
}
