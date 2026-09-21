//
//  BusLayout.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import Foundation

/// Describes the physical layout of a bus. Change these values and the whole UI adapts.
struct BusLayout: Identifiable, Hashable {
    let name: String
    let rows: Int
    let leftColumns: Int
    let rightColumns: Int
    /// When true, the last row has an extra seat where the aisle would be.
    var fullBackRow: Bool = false
    let basePrice: Double
    var windowSurcharge: Double = 0
    var currencyCode: String = "AUD"

    var id: String { name }

    // MARK: Presets

    static let standard = BusLayout(name: "Standard 2+2", rows: 11, leftColumns: 2, rightColumns: 2,
                                    fullBackRow: true, basePrice: 25, windowSurcharge: 5)
    static let luxury   = BusLayout(name: "Luxury 2+1", rows: 9, leftColumns: 2, rightColumns: 1,
                                    basePrice: 45, windowSurcharge: 5)
    static let minibus  = BusLayout(name: "Minibus 1+2", rows: 6, leftColumns: 1, rightColumns: 2,
                                    fullBackRow: true, basePrice: 18)

    static let presets: [BusLayout] = [.standard, .luxury, .minibus]

    // MARK: Building

    /// Builds the grid and the seat dictionary from the layout description.
    func build() -> (grid: [[GridCell]], seats: [String: Seat]) {
        let letters = Array("ABCDEFGHIJ")
        let totalColumns = leftColumns + 1 + rightColumns
        var grid: [[GridCell]] = []
        var seats: [String: Seat] = [:]

        for row in 1...rows {
            let isBackRow = fullBackRow && row == rows
            var cells: [GridCell] = []
            var letterIndex = 0

            for column in 0..<totalColumns {
                if column == leftColumns && !isBackRow {
                    cells.append(GridCell(id: "aisle-\(row)", seatID: nil, row: row))
                    continue
                }
                let seatID = "\(row)\(letters[letterIndex])"
                letterIndex += 1
                let isWindow = column == 0 || column == totalColumns - 1
                seats[seatID] = Seat(id: seatID,
                                     row: row,
                                     isWindow: isWindow,
                                     price: basePrice + (isWindow ? windowSurcharge : 0))
                cells.append(GridCell(id: seatID, seatID: seatID, row: row))
            }
            grid.append(cells)
        }
        return (grid, seats)
    }
}
