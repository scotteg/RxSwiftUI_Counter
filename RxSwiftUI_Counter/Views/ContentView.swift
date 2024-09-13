//
//  ContentView.swift
//  RxSwiftUI_Counter
//
//  Created by Scott Gardner on 9/13/24.
//

import SwiftUI

/// The main view that displays the current counter value and allows the user to start, stop, and reset the counter
/// using buttons.
struct ContentView: View {
    /// Tracks whether the counter is currently running.
    @State private var isRunning = false

    /// Binds the counter relay from the view model to the SwiftUI view.
    @RxRelay private var counterRelay: Int

    /// The view model that manages the counter logic.
    private let viewModel = ContentViewModel()

    /// Initializes the `ContentView` and sets up the relay binding.
    init() {
        _counterRelay = RxRelay(relay: viewModel.counterRelay) // Bind to the counter relay from the view model.
    }

    /// The body of the view, containing the current counter and control buttons.
    var body: some View {
        VStack {
            Text("\(counterRelay)")
                .font(.system(size: 150, weight: .bold))
                .transition(.opacity)
                .animation(.easeInOut, value: counterRelay)
                .padding()

            HStack(spacing: 50) {
                Button(action: toggleCounter) {
                    Text(isRunning ? "Stop" : "Start")
                        .font(.title)
                        .padding()
                        .background(isRunning ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: resetCounter) {
                    Text("Reset")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isRunning)
                .opacity(isRunning ? 0.5 : 1.0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .ignoresSafeArea()
    }

    /// Toggles the counter between running and stopped, and updates the button label.
    private func toggleCounter() {
        viewModel.toggleCounter()
        isRunning.toggle() // Toggle the running state.
    }

    /// Resets the counter value to 0 and updates the start/stop button to "Start".
    private func resetCounter() {
        viewModel.resetCounter()
        isRunning = false // Set isRunning to false after resetting.
    }
}

#Preview {
    ContentView()
}
