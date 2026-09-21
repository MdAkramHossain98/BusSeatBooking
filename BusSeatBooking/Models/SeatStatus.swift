//
//  SeatStatus.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import Foundation

/// The booking state of a single seat.
enum SeatStatus: Equatable, CaseIterable {
    case available
    case selected
    case booked

    var title: String {
        switch self {
        case .available: return "Available"
        case .selected:  return "Selected"
        case .booked:    return "Booked"
        }
    }
}
