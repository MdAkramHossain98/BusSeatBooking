//
//  BusDeckView.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import SwiftUI

/// The bus outline with the driver area and the seat grid.
struct BusDeckView: View {
    @ObservedObject var viewModel: SeatBookingViewModel
    let seatSize: CGFloat
    private let spacing: CGFloat = 8

    var body: some View {
        VStack(spacing: spacing) {
            driverArea
            Divider().padding(.bottom, 4)
            seatGrid
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 2)
        )
        .frame(maxWidth: .infinity)
    }

    private var driverArea: some View {
        HStack {
            Label("Door", systemImage: "door.left.hand.open")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Image(systemName: "steeringwheel")
                .font(.title2)
                .foregroundStyle(.secondary)
                .accessibilityLabel("Driver")
        }
        .padding(.bottom, 4)
    }

    private var seatGrid: some View {
        ForEach(Array(viewModel.grid.enumerated()), id: \.offset) { _, row in
            HStack(spacing: spacing) {
                ForEach(row) { cell in
                    if let seatID = cell.seatID, let seat = viewModel.seats[seatID] {
                        SeatView(seat: seat, size: seatSize) {
                            viewModel.toggle(seatID)
                        }
                    } else {
                        aisle(row: cell.row)
                    }
                }
            }
        }
    }

    /// The aisle shows the row number.
    private func aisle(row: Int) -> some View {
        Text("\(row)")
            .font(.caption2.monospacedDigit())
            .foregroundStyle(.tertiary)
            .frame(width: seatSize, height: seatSize)
            .accessibilityHidden(true)
    }
}
