//
//  RxRelay.swift
//  RxSwiftUI_Counter
//
//  Created by Scott Gardner on 9/13/24.
//

import RxCocoa
import RxSwift
import SwiftUI

/// A property wrapper that binds a `BehaviorRelay` to a SwiftUI view, allowing seamless updates to the view when the
/// relay emits new values.
@propertyWrapper
struct RxRelay<Value>: DynamicProperty {
    /// The current state of the value, managed by SwiftUI.
    @State private var value: Value

    /// Tracks whether we have already subscribed to avoid multiple subscriptions.
    @State private var isSubscribed = false

    /// The `BehaviorRelay` that emits values.
    private let relay: BehaviorRelay<Value>

    /// The externally managed `DisposeBag`.
    private let disposeBag: DisposeBag

    /// The wrapped value for this property wrapper.
    var wrappedValue: Value {
        get { value }
        set {
            value = newValue
            relay.accept(newValue) // Relay accepts the new value and propagates it.
        }
    }

    /// Initializes the `RxRelay` with a `BehaviorRelay` and an externally managed `DisposeBag`.
    init(relay: BehaviorRelay<Value>, disposeBag: DisposeBag) {
        self.relay = relay
        self.disposeBag = disposeBag
        _value = State(initialValue: relay.value) // Initialize with the relay's current value.
    }

    /// Called automatically by SwiftUI to keep the property wrapper in sync with the relay's values.
    func update() {
        if !isSubscribed {
            subscribeToRelay()
        }
    }

    /// Subscribes to the relay and ensures the subscription is properly managed.
    private func subscribeToRelay() {
        relay
            .observe(on: MainScheduler.instance) // Ensure updates happen on the main thread.
            .subscribe(onNext: { newValue in
                DispatchQueue.main.async {
                    value = newValue
                }
            })
            .disposed(by: disposeBag)

        DispatchQueue.main.async {
            isSubscribed = true
        }
    }
}
