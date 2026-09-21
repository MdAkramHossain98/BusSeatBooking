//
//  SeatBookingView.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import SwiftUI

/// The full seat booking screen. Put it inside a NavigationStack.
struct SeatBookingView: View {
    @StateObject private var viewModel: SeatBookingViewModel
    private let seatSize: CGFloat

    init(layout: BusLayout,
         maxSeats: Int = 6,
         seatSize: CGFloat = 46,
         service: (any SeatBookingService)? = nil) {
        self.seatSize = seatSize
        _viewModel = StateObject(wrappedValue: SeatBookingViewModel(
            layout: layout,
            service: service ?? MockSeatBookingService(layout: layout),
            maxSelectable: maxSeats
        ))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SeatBookingHeader(viewModel: viewModel)
                SeatLegendView()
                BusDeckView(viewModel: viewModel, seatSize: seatSize)
                    .overlay {
                        if viewModel.isLoading && viewModel.selectedSeats.isEmpty {
                            ProgressView().controlSize(.large)
                        }
                    }
            }
            .padding()
        }
        .refreshable { await viewModel.refresh() }
        .safeAreaInset(edge: .bottom) {
            BookingSummaryBar(viewModel: viewModel)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Clear") { viewModel.clearSelection() }
                    .disabled(viewModel.selectedSeats.isEmpty || viewModel.isBooking)
            }
        }
        .task {
            await viewModel.refresh()
            viewModel.startLiveUpdates()
        }
        .onDisappear { viewModel.stopLiveUpdates() }
        .alert(item: $viewModel.alert) { item in
            Alert(title: Text(item.title),
                  message: Text(item.message),
                  dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    NavigationStack {
        SeatBookingView(layout: .standard)
    }
}
