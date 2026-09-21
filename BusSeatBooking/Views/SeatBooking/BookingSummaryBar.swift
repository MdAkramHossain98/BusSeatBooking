//
//  BookingSummaryBar.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import SwiftUI

/// Bottom bar showing the selected seats, total price and the book button.
struct BookingSummaryBar: View {
    @ObservedObject var viewModel: SeatBookingViewModel

    private var count: Int { viewModel.selectedSeats.count }
    private var seatWord: String { count == 1 ? "seat" : "seats" }

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                selectionInfo
                Spacer()
                totalPrice
            }
            bookButton
        }
        .padding()
        .background(.bar)
    }

    private var selectionInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(count == 0 ? "Tap a seat to select it" : "\(count) \(seatWord) selected")
                .font(.subheadline.weight(.semibold))
            if count > 0 {
                Text(viewModel.selectedSeats.map(\.id).joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
    }

    private var totalPrice: some View {
        Text(viewModel.totalPrice, format: .currency(code: viewModel.layout.currencyCode))
            .font(.title3.weight(.bold).monospacedDigit())
            .contentTransition(.numericText())
            .animation(.default, value: viewModel.totalPrice)
    }

    private var bookButton: some View {
        Button {
            Task { await viewModel.confirmBooking() }
        } label: {
            Group {
                if viewModel.isBooking {
                    ProgressView().tint(.white)
                } else {
                    Text(count == 0 ? "Book seats" : "Book \(count) \(seatWord)")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .controlSize(.large)
        .disabled(count == 0 || viewModel.isBooking)
    }
}
