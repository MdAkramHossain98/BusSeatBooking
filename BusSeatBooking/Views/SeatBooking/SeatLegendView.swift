//
//  SeatLegendView.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import SwiftUI

/// Explains what each seat color means.
struct SeatLegendView: View {
    var body: some View {
        HStack(spacing: 18) {
            ForEach(SeatStatus.allCases, id: \.self) { status in
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(status.fill)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(status.stroke, lineWidth: 1.5)
                        )
                        .frame(width: 18, height: 18)
                    Text(status.title)
                        .font(.caption)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    SeatLegendView()
}
