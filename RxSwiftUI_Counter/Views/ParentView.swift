//
//  ParentView.swift
//  RxSwiftUI_Counter
//
//  Created by Scott Gardner on 9/13/24.
//

import SwiftUI

/// A simple parent view that contains the `ContentView` and re-renders it when the `showCounter` state changes.
struct ParentView: View {
    @State private var showCounter = false // Set to false initially to not show the ContentView at first.

    var body: some View {
        VStack {
            if showCounter {
                ContentView()
                    .transition(.slide)
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(showCounter ? "Hide Counter" : "Show Counter") {
                    showCounter.toggle()
                }
                .padding(5)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
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
