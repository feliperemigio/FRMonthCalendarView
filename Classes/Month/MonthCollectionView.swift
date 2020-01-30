//
//  MonthCollectionView.swift
//  CalendarView
//
//  Created by Felipe Remigio on 14/10/19.
//  Copyright © 2019 tvglobo. All rights reserved.
//

import UIKit
import Foundation

private let cellReuseIdentifier = "MonthDayCollectionViewCell"
private let headerReuseIdentifier = "MonthHeaderCollectionReusableView"

protocol MonthCollectionViewProtocol {
    var minDate: Date { get set }
    var maxDate: Date { get set }
    var allowMultipleSelection: Bool { get set }
}

final class MonthCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout, MonthCollectionViewProtocol  {
    var minDate = Date()
    var maxDate = Calendar.current.date(byAdding: .year, value: 3, to: Date())!
    
    var allowMultipleSelection: Bool = false
    var availableDays: [Int]? = nil
    var eventsDays: [Int]? = nil
    
    private let days = 7
    
    private var appearance: CalendarViewAppearance? = nil {
        didSet {
            guard let appearance = self.appearance else {
                return
            }
            
            var extraSpace: CGFloat = 0.0
            
            let columnSpacing = appearance.columnSpacing
            let totalSpacing = columnSpacing * CGFloat(self.days - 1)
            let contentSize = appearance.calendarView.bounds.width - totalSpacing
            let minimumWidth = contentSize / CGFloat(self.days)
            
            guard appearance.dayItemSize.width < minimumWidth else {
                sizeItem = CGSize(width: minimumWidth, height: appearance.dayItemSize.height)
                return
            }
            extraSpace = appearance.calendarView.bounds.width - (appearance.dayItemSize.width * CGFloat(self.days) + totalSpacing)
            sizeItem = appearance.dayItemSize
            self.collectionView.contentInset = UIEdgeInsets(top: 0, left: extraSpace/2, bottom: 0, right: extraSpace/2)
        }
    }
    
    private var sizeItem: CGSize = CGSize(width: 40, height: 40)
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        self.view.backgroundColor = .clear
        self.collectionView.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(DayCollectionViewCell.self,
                                     forCellWithReuseIdentifier: cellReuseIdentifier)
        self.collectionView.register(MonthHeaderCollectionReusableView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: headerReuseIdentifier)
        guard  let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {  return }
        layout.scrollDirection = .vertical
    }
    
    private func isEnabled(date: Date?) -> Bool {
        guard let date = date else {
            return false
        }
        
        return self.availableDays?.contains(date.day) ?? true
    }
    
    private func hasEvent(date: Date?) -> Bool {
        guard let date = date else {
            return false
        }
        
        return self.eventsDays?.contains(date.day) ?? true
    }
    
    //MARK: CollectionViewDelegate & CollectionViewDatasource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let months = Calendar.current.dateComponents([.month], from: self.minDate, to: self.maxDate)
        return months.month! + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDate = createDate(withMonthPosition: section)
        let blankDays = firstDate.firstWeekday - 1
        return self.days + blankDays + firstDate.daysInMonth
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! DayCollectionViewCell
        if let appearance = self.appearance {
            cell.applyAppearance(appearance: appearance)
        }
        
        if self.isWeekday(position: indexPath.item){
            cell.configure(withWeekday: indexPath.item + 1)
        } else if self.isBlankDay(indexPath: indexPath) {
            cell.configure(withDate: nil)
        } else {
            let date = self.createDate(withIndexPath: indexPath)
            cell.configure(withDate: date)
            
            if !self.isEnabled(date: date)  {
                cell.disable()
            }
            
            if self.hasEvent(date: date)  {
                cell.shouldDisplayEvents()
            }
            
            guard let selectedStart = self.appearance?.calendarView.selectedStartDate else{
                return cell
            }
            
            guard !self.isBetweenSelection(date: date) else {
                cell.selectHightlight()
                if self.hasEvent(date: date)  {
                    cell.shouldDisplayEvents()
                }
                return cell
            }
            
            if date.equalsDay(date: selectedStart) {
                cell.select()
                if self.appearance?.calendarView.selectedEndDate != nil{
                    cell.selectHalfRight()
                }
            } else if let selectedEnd = self.appearance?.calendarView.selectedEndDate, date.equalsDay(date: selectedEnd) {
                cell.select()
                cell.selectHalfLeft()
            }
            
            if self.hasEvent(date: date)  {
                cell.shouldDisplayEvents()
            }
            
            
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
        guard self.isEnabled(date: cell.date) else {
            return
        }
        
        guard let date = cell.date else {
            return
        }
        
        if allowMultipleSelection, let selectedStartDate = self.appearance?.calendarView.selectedStartDate, date > selectedStartDate, self.appearance?.calendarView.selectedEndDate == nil {
            self.appearance?.calendarView.selectDates(startDate: selectedStartDate, endDate: date)
        } else {
            self.appearance?.calendarView.selectDates(startDate: date, endDate: nil)
        }
    
        guard let selectedStartDate = self.appearance?.calendarView.selectedStartDate,  let calendarView = self.appearance?.calendarView else {
            return
        }
        
        calendarView.delegate?.calendarView(calendarView: calendarView, didSelectDates: selectedStartDate, secondDate: self.appearance?.calendarView.selectedEndDate)
    }
    
    
    //MARK: CollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.sizeItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: self.appearance?.monthHeight ?? 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? MonthHeaderCollectionReusableView else {
            return UICollectionReusableView(frame: .zero)
        }
        
        let firstDate = createDate(withMonthPosition: indexPath.section)
        headerView.configure(name: firstDate.shortDate.firstCapitalized)
        if let appearance = self.appearance {
            headerView.applyAppearance(appearance: appearance)
        }
        
        return headerView
    }
    
    
    //MARK: - Private functions
    
    private func isBetweenSelection(date: Date) -> Bool {
        guard let selectedStartDate = self.appearance?.calendarView.selectedStartDate,
            let selectedEndDate = self.appearance?.calendarView.selectedEndDate else {
                return false
        }
        
        return date > selectedStartDate && date < selectedEndDate
    }
    
    private func isWeekday(position: Int) -> Bool {
        return position < self.days
    }
    
    private func isBlankDay(indexPath: IndexPath) -> Bool {
        let blankDays = createDate(withMonthPosition: indexPath.section).firstWeekday - 1
        return indexPath.item < self.days + blankDays
    }
    
    private func createDate(withIndexPath indexPath: IndexPath) -> Date {
        let blankDays = createDate(withMonthPosition: indexPath.section).firstWeekday - 1
        let day = indexPath.item - (self.days + blankDays) + 1
        return createDate(withDay: day, monthPosition: indexPath.section)
    }
    
    private func createDate(withDay day: Int, monthPosition at: Int) -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: createDate(withMonthPosition: at))
        components.day = day
        return Calendar.current.date(from: components)!
    }
    
    private func createDate(withMonthPosition at: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: at, to: self.minDate.firstDate)!
    }
}

extension MonthCollectionView: AppearanceProtocol {
    func applyAppearance(appearance: CalendarViewAppearance) {
        defer {
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
        
        self.appearance = appearance
        
        if self.appearance?.scrollDirection == .vertical {
            self.collectionView.isScrollEnabled = false
        }
        
        guard  let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {  return }
        layout.minimumInteritemSpacing = appearance.columnSpacing
        layout.minimumLineSpacing = appearance.lineSpacing
    }
}
