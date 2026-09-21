//
//  Haptics.swift
//  BusSeatBooking
//
//  Created by Akram on 21/9/26.
//

import UIKit

/// Small wrapper so the rest of the app doesn't need to know about UIKit feedback generators.
@MainActor
enum Haptics {
    static func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
