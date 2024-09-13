//
//  ParentView.swift
//  RxSwiftUI_Counter
//
//  Created by Scott Gardner on 9/13/24.
//

import SwiftUI

/// A simple parent view that contains the `ContentView` and re-renders it when the `showCounter` state changes.
struct ParentView: View {
    @State private var showCounter = false
    @State private var parentUpdateCounter = 0
    private var viewModel = ViewModel()

    var body: some View {
        VStack {
            if showCounter {
                ContentView(viewModel: viewModel)
                    .transition(.slide)
            }

            Button(showCounter ? "Hide Counter" : "Show Counter") {
                showCounter.toggle()
            }
            .padding(10)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)

            Button("Update Parent View") {
                parentUpdateCounter += 1 // Causes the parent to rerender.
            }
            .padding(10)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Text("Parent View Updates: \(parentUpdateCounter)")
                .padding()
                .font(.headline)
        }
        .animation(.easeInOut, value: showCounter)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .ignoresSafeArea()
    }
}

#Preview {
    ParentView()
}
