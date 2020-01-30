//
//  CalendarView.swift
//  CalendarView
//
//  Created by Felipe Remigio on 14/10/19.
//  Copyright © 2019 tvglobo. All rights reserved.
//

import UIKit
import Foundation

@objc public protocol CalendarViewDataSource: AnyObject {
    @objc optional func dates(at month: Date) -> [Date]?
    @objc optional func datesWithEvents(at month: Date) -> [Date]?
}

public protocol CalendarViewDelegate: AnyObject {
    func calendarView(calendarView: CalendarView,  didSelectDates firstDate: Date, secondDate: Date?)
    func calendarView(calendarView: CalendarView,  endDisplayMonth month: Date)
}

public final class CalendarView: UIView {
    
    public weak var dataSource: CalendarViewDataSource?
    public weak var delegate: CalendarViewDelegate?
    
    public var appearance: CalendarViewAppearance!
    
    public var minDate = Date() {
        didSet { self.calendarViewController.minDate = self.minDate }
    }
    
    public var maxDate: Date = Calendar.current.date(byAdding: .year, value: 3, to: Date()) ?? Date() {
        didSet { self.calendarViewController.maxDate = self.maxDate }
    }
    
    public var currentMonth: Date? = nil {
        didSet {
            guard oldValue == nil else {
                return
            }
            
            self.alpha = 0
            UIView.animate(withDuration: 0.2, delay: 0.6, options: .curveEaseIn, animations: {
                self.alpha = 1
            }, completion: nil)
            
            self.calendarViewController.currentMonth = self.currentMonth
        }
    }
    
    public var selectedStartDate: Date? = nil
    
    public var selectedEndDate: Date? = nil 
    
    public var allowMultipleSelection = false {
        didSet { self.calendarViewController.allowMultipleSelection = self.allowMultipleSelection }
    }
    
    public private(set) var controlButtonRight: UIButton? = nil
    public private(set) var controlButtonLeft: UIButton? = nil
    
    public var isControlActive: Bool = false {
        didSet {
            self.controlsView?.removeFromSuperview()
            guard isControlActive else {
                return
            }
            
            self.createControlsView()
        }
    }
    
    private var controlsView: UIView? = nil
    private var calendarViewController: CalendarCollectionViewController!
    
    public init(minDate: Date, maxDate: Date) {
        super.init(frame: .zero)
        calendarViewController = CalendarCollectionViewController(minDate: minDate,
                                                                  maxDate: maxDate,
                                                                  collectionViewLayout: UICollectionViewFlowLayout())
        self.initialize()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        self.calendarViewController = CalendarCollectionViewController(minDate: Date(),
                                                                       maxDate: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date(),
                                                                       collectionViewLayout: UICollectionViewFlowLayout())
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.calendarViewController = CalendarCollectionViewController(minDate: Date(),
                                                                       maxDate: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date(),
                                                                       collectionViewLayout: UICollectionViewFlowLayout())
        self.initialize()
    }
    
    private func initialize() {
        self.backgroundColor = .clear
        self.appearance = CalendarViewAppearance(self)
        self.addSubview(self.calendarViewController.collectionView)
        self.calendarViewController.collectionView.anchorToBounds(view: self)
    }
    
    func hideControls() {
        UIView.animate(withDuration: 0.2) {
            self.controlsView?.alpha = 0
        }
    }
    
    func showControls() {
        UIView.animate(withDuration: 0.2) {
            self.controlsView?.alpha = 1
        }
    }
    
    func applyAppearance() {
        self.calendarViewController.applyAppearance(appearance: self.appearance)
        
        if self.appearance.scrollDirection == .vertical {
            self.isControlActive = false
            self.controlsView?.removeFromSuperview()
            self.controlsView = nil
        } else if self.isControlActive {
            self.isControlActive = true
        }
    }
    
    func selectDates(startDate: Date, endDate: Date?) {
        self.selectedStartDate = startDate
        self.selectedEndDate = endDate
        self.calendarViewController.collectionView.reloadItems(at: self.calendarViewController.collectionView.indexPathsForVisibleItems)
    }
    
    private func createControlsView() {
        guard self.appearance.scrollDirection == .horizontal else { return }
        self.controlsView = UIView()
        self.controlButtonLeft = UIButton()
        self.controlButtonLeft?.setTitle("<", for: .normal)
        self.controlButtonLeft?.addTarget(self.calendarViewController, action: #selector(self.calendarViewController.didTouchPrevious), for: .touchUpInside)
        self.controlButtonRight  = UIButton()
        self.controlButtonRight?.setTitle(">", for: .normal)
        self.controlButtonRight?.addTarget(self.calendarViewController, action: #selector(self.calendarViewController.didTouchNext), for: .touchUpInside)
        
        self.addToControlView(button: self.controlButtonLeft)
        self.addToControlView(button: self.controlButtonRight)
        
        guard let controlsView = self.controlsView else {
            return
        }
        
        self.controlButtonLeft?.anchor(leading: controlsView.leadingAnchor)
        self.controlButtonRight?.anchor(trailing: controlsView.trailingAnchor)
        
        self.addSubview(controlsView)
        controlsView.anchorCenterXToSuperview()
        controlsView.anchor(height: self.appearance.monthHeight, width: self.appearance.calendarWidth)
    }
    
    private func addToControlView(button: UIButton?) {
        guard let button = button, let controlsView = self.controlsView else {
            return
        }
        
        controlsView.addSubview(button)
        button.anchorCenterYToSuperview()
        button.anchor(height: 40, width: 40)
    }
}

