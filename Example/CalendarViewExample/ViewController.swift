//
//  ViewController.swift
//  CalendarViewExample
//
//  Created by Felipe Remigio on 27/09/19.
//  Copyright © 2019 tvglobo. All rights reserved.
//

import UIKit
import FRMonthCalendarView

final class ViewController: UIViewController {
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendarView.backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        self.calendarView.appearance?.monthTextAttributes = [.foregroundColor: UIColor.white,]
        self.calendarView.appearance?.monthSelectedTextAttributes = [.foregroundColor: UIColor.white]
        self.calendarView.appearance?.tintColor = UIColor(red: 243/255, green: 29/255, blue: 29/255, alpha: 1)
        self.calendarView.appearance?.yearTextAttributes = [.foregroundColor: UIColor.black]
        self.calendarView.appearance?.disabledTextAttributes = [.foregroundColor: UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1)]
        self.calendarView.appearance?.columnSpacing = 0
        self.calendarView.appearance?.yearHeight = 88
        self.calendarView.appearance?.timeZone = TimeZone(abbreviation: "GMT")
        self.calendarView.appearance?.scrollDirection = .vertical
        self.calendarView.appearance?.separatorHeight = 1
        self.calendarView.appearance?.separatorColor = .white
        self.calendarView.appearance?.monthSelectedCornerRadius = 10
        self.calendarView.appearance?.monthItemSize = CGSize(width: 56, height: 56)
        self.calendarView.appearance?.backgroundDayBetweenSelectedDatesHeight = 46
        
        
        self.calendarView.minDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
        self.calendarView.maxDate = Calendar.current.date(byAdding: .month, value: 4, to: Date()) ?? Date()
        self.calendarView.allowMultipleSelection = true
        self.calendarView.currentMonth = Calendar.current.date(byAdding: .month, value: 2, to: Date())!
        self.calendarView.selectedStartDate = Calendar.current.date(byAdding: .month, value: 2, to: Date())!
        self.calendarView.isControlActive = true
        
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

extension ViewController: CalendarViewDataSource {
    
}

extension ViewController: CalendarViewDelegate {
    func calendarView(calendarView: CalendarView, endDisplayMonth month: Date) {
        
    }
    
    func calendarView(calendarView: CalendarView, didSelectDates firstDate: Date, secondDate: Date?) {
        
    }
}
