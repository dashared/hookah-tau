//
//  AdminReservationView.swift
//  Hookah Tau
//
//  Created by cstore on 19/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminReservationView: UIView {
    
    // MARK:- IBAOutlets
    
    @IBOutlet weak var tableLabel: UILabel?
    
    @IBOutlet weak var dateLabel: UILabel?
    
    @IBOutlet weak var timeLabel: UILabel?
    
    @IBOutlet weak var cancelButton: Button? {
        didSet {
            let style = BlackButtonStyle()
            style.apply(to: cancelButton)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel?
    
    @IBOutlet weak var callButton: Button? {
        didSet {
            let style = BlackButtonStyle()
            style.apply(to: callButton)
        }
    }
    
    @IBOutlet weak var numberOfGuestLabel: UILabel?
    
    @IBOutlet weak var guestSlider: UISlider?
    
    @IBOutlet weak var intervalsContainerView: UIView?
    
    // MARK:- Properties
    
    var intervalPickerView: IntervalPickerView?
    
    /// Модель вьюшки.
    /// Обновляем каждый раз когда меняется время и дата
    var data: ReservationData?
    
    // MARK: - Setup
    
    func bind(withModel model: ReservationData) {
        
    }
    
    func updateDateAndTime(withData d: ReservationData?) {
        guard let d = d else { return }
        let (date, time) = Date.format(d.startTime, d.endTime)
        
        dateLabel?.text = date
        timeLabel?.text = time
    }
}


extension AdminReservationView: PickerViewUpdater {
    
    func update(withModel model: IntervalPickerModel) {
        guard let d = data else { return }
        
        data = ReservationData(establishment: d.establishment,
                               startTime: model.startTime,
                               endTime: model.endTime,
                               numberOfGuests: d.numberOfGuests,
                               reservedTable: d.reservedTable)
        
        updateDateAndTime(withData: data)
    }
}
