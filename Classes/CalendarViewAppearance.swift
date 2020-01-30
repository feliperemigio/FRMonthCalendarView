//
//  CalendarViewAppearance.swift
//  CalendarView
//
//  Created by Felipe Remigio on 17/10/19.
//  Copyright © 2019 tvglobo. All rights reserved.
//

import UIKit

protocol AppearanceProtocol {
    func applyAppearance(appearance: CalendarViewAppearance)
}

public final class CalendarViewAppearance: NSObject {
    private(set) weak var calendarView: CalendarView!
    
    public var dayTextAttributes: [NSAttributedString.Key: Any] = [:] { didSet { self.calendarView.applyAppearance() } }
    public var daySelectedTextAttributes: [NSAttributedString.Key: Any] = [:] { didSet { self.calendarView.applyAppearance() } }
    public var weekdayTextAttributes: [NSAttributedString.Key: Any] = [:] { didSet { self.calendarView.applyAppearance() } }
    public var monthTextAttributes: [NSAttributedString.Key: Any] = [:] { didSet { self.calendarView.applyAppearance() } }
    public var tintColor: UIColor = .blue { didSet { self.calendarView.applyAppearance() } }
    public var disabledTextAttributes: [NSAttributedString.Key: Any] = [:] { didSet { self.calendarView.applyAppearance() } }
    public var columnSpacing: CGFloat = 0.0 { didSet { self.calendarView.applyAppearance() } }
    public var lineSpacing: CGFloat = 0.0 { didSet { self.calendarView.applyAppearance() } }
    public var dayItemSize: CGSize = CGSize(width: 40, height: 40) { didSet { self.calendarView.applyAppearance() } }
    public var monthHeight: CGFloat = 50 { didSet { self.calendarView.applyAppearance() } }
    public var timeZone: TimeZone? = nil {
        didSet {
            guard let timeZone = self.timeZone else { return }
            NSTimeZone.default = timeZone
        }
    }
    public var separatorHeight: CGFloat = 0 { didSet { self.calendarView.applyAppearance() } }
    public var separatorColor: UIColor = .gray { didSet { self.calendarView.applyAppearance() } }
    
    public var weekDayCharactersLimit: Int = 1 { didSet { self.calendarView.applyAppearance() } }
    
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal { didSet { self.calendarView.applyAppearance() } }
    
    public var daySelectedCornerRadius: CGFloat? { didSet { self.calendarView.applyAppearance() } }
    public var backgroundDayBetweenSelectedDatesHeight: CGFloat? = nil { didSet { self.calendarView.applyAppearance() } }
    
    var calendarWidth: CGFloat {
        let days = 7
        let columnSpacing = self.columnSpacing
        let totalSpacing = columnSpacing * CGFloat(days - 1)
        let contentSize = self.calendarView.bounds.width - totalSpacing
        let minimumWidth = contentSize / CGFloat(days)
        guard self.dayItemSize.width < minimumWidth else {
            return minimumWidth * CGFloat(days)
        }
        
        return (dayItemSize.width * CGFloat(days) + totalSpacing)
    }
    
    var calendarHeight: CGFloat {
        let lines = 7
        let lineSpacing = self.lineSpacing
        let totalSpacing = lineSpacing * CGFloat(lines - 1) + self.monthHeight
        
        return (dayItemSize.height * CGFloat(lines) + totalSpacing)
    }
    
    init(_ calendarView: CalendarView) {
        self.calendarView = calendarView
        super.init()
    }
}
