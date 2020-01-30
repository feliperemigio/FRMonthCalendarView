//
//  String+Formatting.swift
//  CalendarView
//
//  Created by Jonathan Pereira Bijos on 18/10/19.
//

extension String {
    var firstCapitalized: String {
        guard let first = self.first else { return "" }
        return String(first).capitalized + self.dropFirst()
    }
}

