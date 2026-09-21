//
//  MockSeatBookingService.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import Foundation

/// A fake backend. Some seats start booked, and other passengers
/// occasionally book seats between refreshes.
actor MockSeatBookingService: SeatBookingService {
    private var booked: Set<String>
    private let allSeatIDs: [String]

    init(layout: BusLayout, occupancy: Double = 0.35) {
        let ids = Array(layout.build().seats.keys)
        allSeatIDs = ids
        booked = Set(ids.shuffled().prefix(Int(Double(ids.count) * occupancy)))
    }

    func fetchUnavailableSeats() async throws -> Set<String> {
        try await Task.sleep(for: .milliseconds(400))
        // Another passenger books a seat now and then
        if Int.random(in: 0..<3) == 0,
           let seat = allSeatIDs.filter({ !booked.contains($0) }).randomElement() {
            booked.insert(seat)
        }
        return booked
    }

    func book(seatIDs: [String]) async throws {
        try await Task.sleep(for: .seconds(1))
        let conflicts = seatIDs.filter { booked.contains($0) }
        guard conflicts.isEmpty else { throw BookingError.seatsUnavailable(conflicts.sorted()) }
        booked.formUnion(seatIDs)
    }
}
