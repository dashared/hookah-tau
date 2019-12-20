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
            style.apply(to: cancelButton, withTitle: "ОТМЕНИТЬ")
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel?
    
    @IBOutlet weak var callButton: Button?
    
    @IBOutlet weak var numberOfGuestLabel: UILabel?
    
    @IBOutlet weak var guestSlider: UISlider?
    
    @IBOutlet weak var intervalsContainerView: UIView?
    
    // MARK:- Properties
    
    var intervalPickerView: IntervalPickerView?
    
    /// Модель вьюшки.
    /// Обновляем каждый раз когда меняется время и дата
    var data: ReservationData?
    
    var model: ReservationWithUser?
    
    // MARK: - Setup
    
    func bind(withModel model: ReservationWithUser) {
        let style = BlackButtonStyle()
        style.apply(to: callButton, withTitle: model.owner.phoneNumber.formattedNumber())
        
        
        let (date, time) = Date.format(model.startTime, model.endTime)
        dateLabel?.text = date
        timeLabel?.text = time
        
        tableLabel?.text = "\(model.reservedTable) столик"
        nameLabel?.text = "\(model.owner.name ?? "❔")"
        
        data = ReservationData(establishment: model.establishment,
                                          startTime: model.startTime,
                                          endTime: model.endTime,
                                          numberOfGuests: model.numberOfGuests,
                                          reservedTable: model.reservedTable)
    }
    
    func bind(withIntervals intervals: [ReservationPeriod]) {
        
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
