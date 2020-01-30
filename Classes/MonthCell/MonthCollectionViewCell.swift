//
//  MonthCollectionViewCell.swift
//  CalendarView
//
//  Created by Felipe Remigio on 14/10/19.
//  Copyright © 2019 tvglobo. All rights reserved.
//

import UIKit

public final class MonthCollectionViewCell: UICollectionViewCell {
    private var monthCollectionView: MonthCollectionView? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.monthCollectionView = MonthCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        guard let collectionView = monthCollectionView?.collectionView else {
            return
        }
        self.contentView.addSubview(collectionView)
        self.monthCollectionView?.collectionView.anchorToBounds(view: self.contentView)
        self.contentView.layoutIfNeeded()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.monthCollectionView?.collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(date: Date, allowMultipleSelection: Bool = false, availableDays: [Int]?, eventsDays: [Int]? = nil) {
        self.monthCollectionView?.minDate = date
        self.monthCollectionView?.maxDate = date
        self.monthCollectionView?.availableDays = availableDays
        self.monthCollectionView?.eventsDays = eventsDays
        self.monthCollectionView?.allowMultipleSelection = allowMultipleSelection
    }
}

extension MonthCollectionViewCell: AppearanceProtocol {
    func applyAppearance(appearance: CalendarViewAppearance) {
        self.monthCollectionView?.applyAppearance(appearance: appearance)
    }
}
