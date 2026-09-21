//
//  Seat.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import Foundation

/// A single seat on the bus.
struct Seat: Identifiable, Hashable {
    /// Human-readable ID such as "3A". Also used when talking to the backend.
    let id: String
    let row: Int
    let isWindow: Bool
    let price: Double
    var status: SeatStatus = .available
}

/// One slot in the seat grid: either a seat or the aisle.
struct GridCell: Identifiable, Hashable {
    let id: String
    /// nil means this cell is the aisle.
    let seatID: String?
    let row: Int
}
