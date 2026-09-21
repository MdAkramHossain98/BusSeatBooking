//
//  SeatStatus+Style.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import SwiftUI

/// Colors for each seat state. Change these to restyle the whole seat map.
extension SeatStatus {
    var fill: Color {
        switch self {
        case .available: return Color(.secondarySystemBackground)
        case .selected:  return .green
        case .booked:    return Color(.systemGray4)
        }
    }

    var stroke: Color {
        switch self {
        case .available: return .green.opacity(0.7)
        case .selected:  return .green
        case .booked:    return Color(.systemGray3)
        }
    }

    var foreground: Color {
        switch self {
        case .available: return .primary
        case .selected:  return .white
        case .booked:    return .secondary
        }
    }
}
