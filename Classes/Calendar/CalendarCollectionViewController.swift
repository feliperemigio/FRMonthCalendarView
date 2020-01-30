//
//  CalendarCollectionViewController.swift
//  CalendarView
//
//  Created by Felipe Remigio on 14/10/19.
//  Copyright © 2019 tvglobo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MonthCollectionViewCell"

protocol CalendarCollectionViewControllerProtocol {
    var minDate: Date { get set }
    var maxDate: Date { get set }
    var currentMonth: Date? { get set }
    var allowMultipleSelection: Bool { get set }
    func didTouchPrevious()
    func didTouchNext()
}

final class CalendarCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CalendarCollectionViewControllerProtocol {
    private var appearance: CalendarViewAppearance!
    private var page = 0
    
    var minDate = Date() {
        didSet { self.collectionView.reloadData() }
    }
    
    var maxDate: Date = Calendar.current.date(byAdding: .year, value: 3, to: Date()) ?? Date(){
        didSet { self.collectionView.reloadData() }
    }
    
    var currentMonth: Date? = nil {
        didSet {
            guard let currentMonth = self.currentMonth,
                currentMonth >= self.minDate,
                currentMonth <= self.maxDate else {
                    return
            }
            let minDateComponents = Calendar.current.dateComponents([.month, .year], from: self.minDate)
            let currentMonthComponents = Calendar.current.dateComponents([.month, .year], from: currentMonth)
            let month = Calendar.current.dateComponents([.month], from: minDateComponents, to: currentMonthComponents)
            
            
            UIView.transition(with: self.collectionView, duration: 0, options: .transitionCrossDissolve, animations: {
                self.collectionView.reloadData()
            }) { _ in
                let minDateComponents = Calendar.current.dateComponents([.month, .year], from: self.minDate)
                let maxDateComponents = Calendar.current.dateComponents([.month, .year], from: self.maxDate)
                let months = Calendar.current.dateComponents([.month], from: minDateComponents, to: maxDateComponents )
                
                guard let row = month.month, let rows = months.month, row < rows + 1 else {
                    return
                }
                
                self.page = row
                self.collectionView.scrollToItem(at: IndexPath(item: row, section: 0), at: .centeredHorizontally, animated: false)
                self.appearance.calendarView.delegate?.calendarView(calendarView: self.appearance.calendarView, endDisplayMonth: self.createDate(withMonthPosition: Int(month.month ?? 0)))
            }
        }
    }
    
    var allowMultipleSelection = false {
        didSet { self.collectionView.reloadData() }
    }
    
    private var isPortrait: Bool = UIDevice.current.orientation.isPortrait
    
    init(minDate: Date, maxDate: Date, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        self.minDate = minDate
        self.maxDate = maxDate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.isPagingEnabled = true
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        guard  let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.scrollDirection = self.appearance?.scrollDirection ?? .horizontal
        layout.minimumLineSpacing = 0
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotated() {
        let isPortrait = UIDevice.current.orientation.isPortrait
        guard self.isPortrait != isPortrait, !UIDevice.current.orientation.isFlat else {
            return
        }
        
        self.isPortrait = isPortrait
        
        UIView.transition(with: self.collectionView, duration: 0, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }) { _ in
            self.appearance.calendarView.applyAppearance()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.scrollToItem(at: IndexPath(item: self.page, section: 0),
                                             at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        }
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let minDateComponents = Calendar.current.dateComponents([.month, .year], from: self.minDate)
        let maxDateComponents = Calendar.current.dateComponents([.month, .year], from: self.maxDate)
        let months = Calendar.current.dateComponents([.month], from: minDateComponents, to: maxDateComponents )
        return months.month! + 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MonthCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let firstDate = createDate(withMonthPosition: indexPath.item)
        let availableDays = self.appearance?.calendarView.dataSource?.dates?(at: firstDate)?.map({$0.day})
        let eventsDays = self.appearance?.calendarView.dataSource?.datesWithEvents?(at: firstDate)?.map({$0.day})
        cell.configure(date: firstDate,
                       allowMultipleSelection: self.allowMultipleSelection,
                       availableDays: availableDays,
                       eventsDays: eventsDays)
        cell.applyAppearance(appearance: self.appearance)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
        }
        
        if layout.scrollDirection == .horizontal {
            return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
        } else {
            return CGSize(width: self.collectionView.bounds.width, height: self.appearance?.calendarHeight ?? self.collectionView.bounds.height)
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func didTouchPrevious() {
        
        guard let item = self.indexPathForVisibleItem?.item,
            item - 1 >= 0 else {
            self.appearance.calendarView.delegate?.calendarView(calendarView: self.appearance.calendarView, endDisplayMonth: self.minDate)
            return
        }
        let page = item - 1
        
        self.collectionView.scrollToItem(at: IndexPath.init(item: page, section: 0),
                                         at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        self.appearance.calendarView.delegate?.calendarView(calendarView: self.appearance.calendarView,
                                                            endDisplayMonth: self.createDate(withMonthPosition: page))
        self.page = page
    }
    
    @IBAction func didTouchNext() {
        let minDateComponents = Calendar.current.dateComponents([.month, .year], from: self.minDate)
        let maxDateComponents = Calendar.current.dateComponents([.month, .year], from: self.maxDate)
        let months = Calendar.current.dateComponents([.month], from: minDateComponents, to: maxDateComponents)
        guard let item = self.indexPathForVisibleItem?.item,
            item + 1 <= (months.month ?? 0) else {
            self.appearance.calendarView.delegate?.calendarView(calendarView: self.appearance.calendarView, endDisplayMonth: self.maxDate)
            return
        }
        let page = item + 1
        self.collectionView.scrollToItem(at: IndexPath(item: page, section: 0),
                                         at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        self.appearance.calendarView.delegate?.calendarView(calendarView: self.appearance.calendarView,
                                                            endDisplayMonth: self.createDate(withMonthPosition: page))
        self.page = page
    }

    
    // MARK: - Private functions
    
    private func createDate(withMonthPosition at: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: at, to: self.minDate.firstDate)!
    }
    
    private var indexPathForVisibleItem: IndexPath? {
        let rectVisible = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let pointVisible = CGPoint(x: rectVisible.midX, y: rectVisible.midY)
        return self.collectionView.indexPathForItem(at: pointVisible)
    }
}

extension CalendarCollectionViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.appearance.calendarView.hideControls()
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.appearance.calendarView.showControls()
        guard let cell = self.collectionView.visibleCells.first else {
            return
        }
        
        let visibleWidth = cell.frame.width
        let offset = targetContentOffset.pointee.x
        let page = ceil(offset / visibleWidth)
        
        let minDateComponents = Calendar.current.dateComponents([.month, .year], from: self.minDate)
        let currentMonthComponents = Calendar.current.dateComponents([.month, .year], from: self.maxDate)
        let rangeMonth = Calendar.current.dateComponents([.month], from: minDateComponents, to: currentMonthComponents)
        let months = rangeMonth.month ?? 0
        
        self.page = Int(page)
        
        if self.page >= months {
            self.appearance.calendarView.delegate?.calendarView(calendarView: self.appearance.calendarView, endDisplayMonth: self.maxDate)
        } else if (self.page <= 0) {
            self.appearance.calendarView.delegate?.calendarView(calendarView: self.appearance.calendarView, endDisplayMonth: self.minDate)
        } else {
            self.appearance.calendarView.delegate?.calendarView(calendarView: self.appearance.calendarView, endDisplayMonth: self.createDate(withMonthPosition: self.page))
        }
    }
}

extension CalendarCollectionViewController: AppearanceProtocol {
    func applyAppearance(appearance: CalendarViewAppearance) {
        self.appearance = appearance
        guard  let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.scrollDirection = self.appearance?.scrollDirection ?? .horizontal
        
        if self.appearance?.scrollDirection == .vertical {
            self.collectionView.isPagingEnabled = false
        }
        
        self.collectionView.visibleCells.forEach({ cell in
            if let calendarMonthCollectionViewCell = cell as? MonthCollectionViewCell {
                calendarMonthCollectionViewCell.applyAppearance(appearance: self.appearance)
            }
        })
    }
}
