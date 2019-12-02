//
//  ReservationCellView.swift
//  Hookah Tau
//
//  Created by cstore on 20/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ReservationView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet weak var adressLabel: UILabel?
    
    @IBOutlet weak var dateLabel: UILabel?
    
    @IBOutlet weak var timeLabel: UILabel?
    
    @IBOutlet weak var maxPeopleLabel: UILabel?
    
    @IBOutlet weak var tableImageView: UIImageView?

    func bind(withModel model: Reservation) {
        guard let table = TotalStorage.standard.getTable(establishment: model.establishment, table: model.reservedTable),
            let establishment = TotalStorage.standard.getEstablishment(model.establishment)
        else { return }
        
        tableImageView?.image = table.image
        adressLabel?.text = establishment.address
        maxPeopleLabel?.text = "\(model.numberOfGuests) " + (2...4 ~= model.numberOfGuests ? "человека" : "человек")
        
        let (date, time) = format(model.startTime, model.endTime)
        dateLabel?.text = date
        timeLabel?.text = time
    }
    
    private func format(_ startDate: Date, _ endDate: Date) -> (date: String, time: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "d MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")

        let dateStr = "\(dateFormatter.string(from: startDate))"
        
        dateFormatter.dateFormat = "HH:mm"
        let timeStr = "\(dateFormatter.string(from: startDate)) — \(dateFormatter.string(from: endDate))"
        
        return (dateStr, timeStr)
    }
}
