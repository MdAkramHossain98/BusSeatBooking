//
//  SeatView.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import SwiftUI

/// A single tappable seat.
struct SeatView: View {
    let seat: Seat
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                headrest
                cushion
            }
            .frame(width: size, height: size)
            .scaleEffect(seat.status == .selected ? 1.06 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: seat.status)
        }
        .buttonStyle(.plain)
        .disabled(seat.status == .booked)
        .accessibilityLabel("Seat \(seat.id)\(seat.isWindow ? ", window" : "")")
        .accessibilityValue(seat.status.title)
        .accessibilityAddTraits(seat.status == .selected ? .isSelected : [])
    }

    private var headrest: some View {
        Capsule()
            .fill(seat.status.stroke)
            .frame(width: size * 0.55, height: 4)
    }

    private var cushion: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(seat.status.fill)
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(seat.status.stroke, lineWidth: 1.5)

            if seat.status == .booked {
                Image(systemName: "person.fill")
                    .font(.system(size: size * 0.32))
            } else {
                Text(seat.id)
                    .font(.system(size: size * 0.27, weight: .semibold, design: .rounded))
            }
        }
        .foregroundStyle(seat.status.foreground)
    }
}

#Preview {
    HStack {
        SeatView(seat: Seat(id: "1A", row: 1, isWindow: true, price: 30), size: 46) {}
        SeatView(seat: Seat(id: "1B", row: 1, isWindow: false, price: 25, status: .selected), size: 46) {}
        SeatView(seat: Seat(id: "1C", row: 1, isWindow: false, price: 25, status: .booked), size: 46) {}
    }
    .padding()
}
