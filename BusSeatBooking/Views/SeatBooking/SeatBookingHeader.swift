//
//  SeatBookingHeader.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import SwiftUI

/// Bus name, seat availability and pricing note.
struct SeatBookingHeader: View {
    @ObservedObject var viewModel: SeatBookingViewModel

    private var layout: BusLayout { viewModel.layout }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(layout.name)
                .font(.headline)

            Text("\(viewModel.availableCount) of \(viewModel.seats.count) seats free, up to \(viewModel.maxSelectable) per booking")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if layout.windowSurcharge > 0 {
                Text("Window seats cost \(layout.windowSurcharge.formatted(.currency(code: layout.currencyCode))) extra.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
