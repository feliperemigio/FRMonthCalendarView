//
//  YearCollectionViewCell.swift
//  CalendarView
//
//  Created by Felipe Remigio on 14/10/19.
//  Copyright © 2019 tvglobo. All rights reserved.
//

import UIKit

public final class YearCollectionViewCell: UICollectionViewCell {
    private var yearCollectionView: YearCollectionView? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.yearCollectionView = YearCollectionView(collectionViewLayout: UICollectionViewFlowLayout())
        guard let collectionView = yearCollectionView?.collectionView else {
            return
        }
        self.contentView.addSubview(collectionView)
        self.yearCollectionView?.collectionView.anchorToBounds(view: self.contentView)
        self.contentView.layoutIfNeeded()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.yearCollectionView?.collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(date: Date, allowMultipleSelection: Bool = false, availableDays: [Int]?, eventsDays: [Int]? = nil) {
        self.yearCollectionView?.minDate = date
        self.yearCollectionView?.maxDate = date
        self.yearCollectionView?.availableDays = availableDays
        self.yearCollectionView?.eventsDays = eventsDays
        self.yearCollectionView?.allowMultipleSelection = allowMultipleSelection
    }
}

extension YearCollectionViewCell: AppearanceProtocol {
    func applyAppearance(appearance: CalendarViewAppearance) {
        self.yearCollectionView?.applyAppearance(appearance: appearance)
    }
}
