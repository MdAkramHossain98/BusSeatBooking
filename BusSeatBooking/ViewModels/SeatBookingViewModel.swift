//
//  SeatBookingViewModel.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import SwiftUI
import Combine

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

/// Holds all seat state and booking logic. The views only read from it and call its methods.
@MainActor
final class SeatBookingViewModel: ObservableObject {
    @Published private(set) var seats: [String: Seat]
    @Published private(set) var isLoading = false
    @Published private(set) var isBooking = false
    @Published var alert: AlertItem?

    let layout: BusLayout
    let grid: [[GridCell]]
    let maxSelectable: Int

    private let service: any SeatBookingService
    private var pollingTask: Task<Void, Never>?

    init(layout: BusLayout, service: any SeatBookingService, maxSelectable: Int = 6) {
        self.layout = layout
        self.service = service
        self.maxSelectable = maxSelectable
        let built = layout.build()
        self.grid = built.grid
        self.seats = built.seats
    }

    // MARK: Derived state

    var selectedSeats: [Seat] {
        seats.values
            .filter { $0.status == .selected }
            .sorted { ($0.row, $0.id) < ($1.row, $1.id) }
    }

    var totalPrice: Double { selectedSeats.reduce(0) { $0 + $1.price } }

    var availableCount: Int { seats.values.filter { $0.status != .booked }.count }

    // MARK: Loading and live updates

    func refresh(showSpinner: Bool = true) async {
        guard !isBooking else { return }
        if showSpinner { isLoading = true }
        defer { isLoading = false }
        do {
            let unavailable = try await service.fetchUnavailableSeats()
            apply(unavailable: unavailable)
        } catch {
            if showSpinner {
                alert = AlertItem(title: "Couldn't load seats",
                                  message: "Check your connection and pull to refresh.")
            }
        }
    }

    func startLiveUpdates(every interval: Duration = .seconds(4)) {
        pollingTask?.cancel()
        pollingTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: interval)
                guard !Task.isCancelled else { return }
                await self?.refresh(showSpinner: false)
            }
        }
    }

    func stopLiveUpdates() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    private func apply(unavailable: Set<String>) {
        var updated = seats
        var lostSelections: [String] = []

        for (id, seat) in seats {
            let isTaken = unavailable.contains(id)
            switch (seat.status, isTaken) {
            case (.selected, true):
                lostSelections.append(id)
                updated[id]?.status = .booked
            case (.available, true):
                updated[id]?.status = .booked
            case (.booked, false):      // a booking was cancelled
                updated[id]?.status = .available
            default:
                break
            }
        }

        withAnimation(.easeInOut(duration: 0.25)) { seats = updated }

        if !lostSelections.isEmpty {
            Haptics.warning()
            alert = AlertItem(
                title: "Seat no longer available",
                message: "Seat \(lostSelections.sorted().joined(separator: ", ")) was just booked by another passenger and has been removed from your selection."
            )
        }
    }

    // MARK: User actions

    func toggle(_ seatID: String) {
        guard !isBooking, let seat = seats[seatID] else { return }

        switch seat.status {
        case .available:
            guard selectedSeats.count < maxSelectable else {
                Haptics.error()
                alert = AlertItem(title: "Seat limit reached",
                                  message: "You can book up to \(maxSelectable) seats per booking.")
                return
            }
            seats[seatID]?.status = .selected
        case .selected:
            seats[seatID]?.status = .available
        case .booked:
            return
        }
        Haptics.selection()
    }

    func clearSelection() {
        for seat in selectedSeats { seats[seat.id]?.status = .available }
    }

    func confirmBooking() async {
        let ids = selectedSeats.map(\.id)
        guard !ids.isEmpty else { return }
        let total = totalPrice

        isBooking = true
        defer { isBooking = false }

        do {
            try await service.book(seatIDs: ids)
            for id in ids { seats[id]?.status = .booked }
            Haptics.success()
            alert = AlertItem(
                title: "Booking confirmed",
                message: "Seat \(ids.joined(separator: ", ")) booked. Total paid: \(total.formatted(.currency(code: layout.currencyCode)))."
            )
        } catch let error as BookingError {
            if case .seatsUnavailable(let conflicts) = error {
                for id in conflicts { seats[id]?.status = .booked }
            }
            Haptics.error()
            alert = AlertItem(title: "Booking not completed", message: error.localizedDescription)
        } catch {
            Haptics.error()
            alert = AlertItem(title: "Booking not completed",
                              message: "Something went wrong. Your seats are still selected, so you can try again.")
        }
    }
}
