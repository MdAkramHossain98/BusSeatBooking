//
//  SeatBookingService.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import Foundation

protocol SeatBookingService: Sendable {
    /// Returns the IDs of every seat that is currently booked.
    func fetchUnavailableSeats() async throws -> Set<String>
    /// Books the given seats. Throws BookingError.seatsUnavailable if any were taken.
    func book(seatIDs: [String]) async throws
}

enum BookingError: LocalizedError {
    case seatsUnavailable([String])

    var errorDescription: String? {
        switch self {
        case .seatsUnavailable(let ids):
            return "Seat \(ids.joined(separator: ", ")) was booked by someone else. Choose another seat and try again."
        }
    }
}
