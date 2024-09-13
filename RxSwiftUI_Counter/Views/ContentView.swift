//
//  ContentView.swift
//  RxSwiftUI_Counter
//
//  Created by Scott Gardner on 9/13/24.
//

import SwiftUI

/// Displays the current counter value and allows the user to start, stop, and reset the counter.
struct ContentView: View {
    @State private var isRunning = false

    @RxRelay private var counterRelay: Int

    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        _counterRelay = RxRelay(relay: viewModel.counterRelay, disposeBag: SubscriptionsManager.shared.disposeBag)
    }

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
        .onDisappear {
            viewModel.stopCounter()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .ignoresSafeArea()
    }

    private func toggleCounter() {
        viewModel.toggleCounter()
        isRunning.toggle()
    }

    private func resetCounter() {
        viewModel.resetCounter()
        isRunning = false
    }
}

#Preview {
    ContentView(viewModel: ViewModel())
}
