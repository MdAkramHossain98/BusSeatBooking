//
//  ContentView.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import SwiftUI

struct ContentView: View {
    @State private var layout: BusLayout = .standard

    var body: some View {
        NavigationStack {
            SeatBookingView(layout: layout)
                .id(layout)     // fresh seat map when the bus type changes
                .navigationTitle("Choose your seats")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Picker("Bus", selection: $layout) {
                                ForEach(BusLayout.presets) { Text($0.name).tag($0) }
                            }
                        } label: {
                            Image(systemName: "bus")
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
