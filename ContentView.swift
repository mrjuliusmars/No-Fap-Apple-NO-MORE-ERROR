//
//  ContentView.swift
//  No Fap Apple
//
//  Created by Marshall Hodge on 5/27/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "smiley")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, worldd!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
