//
//  MonthHeaderCollectionReusableView.swift
//  CalendarView
//
//  Created by Felipe Remigio on 14/10/19.
//  Copyright © 2019 tvglobo. All rights reserved.
//

import UIKit

final class MonthHeaderCollectionReusableView: UICollectionReusableView {
    private var appearance: CalendarViewAppearance? = nil
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.nameLabel)
        self.nameLabel.anchor(leading: self.leadingAnchor, trailing: self.trailingAnchor)
        self.nameLabel.anchorCenterYToSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String) {
        self.nameLabel.attributedText = NSAttributedString(string: name,
                                                           attributes: self.appearance?.monthTextAttributes)
    }
}

extension MonthHeaderCollectionReusableView: AppearanceProtocol {
    func applyAppearance(appearance: CalendarViewAppearance) {
        self.appearance = appearance
        self.configure(name: self.nameLabel.text ?? "")
    }
}
