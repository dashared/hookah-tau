//
//  ThirdStepView.swift
//  Hookah Tau
//
//  Created by cstore on 23/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

struct ThirdStepViewModel {
    var timeIntervalView: UIView
}

class ThirdStepView: UIView {
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var closeButton: Button! {
        didSet {
            let style = BlackButtonStyle()
            style.apply(to: closeButton, withTitle: "ЗАКРЫТЬ")
        }
    }
    
    @IBOutlet weak var timeInterval: UIView!
    
    func bind(withModel model: Reservation) {
        let date = format(model.startTime, model.endTime)
        
        totalLabel.text = "Забронирован \(model.reservedTable) столик на \(model.numberOfGuests)-х\n \(date)"
        
        infoLabel.text = "Минимальное количество кальянов: \(countTotalNumber(model.numberOfGuests))"
    }
    
    private func format(_ startDate: Date, _ endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MM.dd, с HH:mm по"

        var newDateString = "\(dateFormatter.string(from: startDate))"
        
        dateFormatter.dateFormat = "HH:mm"
        newDateString += " \(dateFormatter.string(from: endDate))"
        
        return newDateString
    }
    
    private func countTotalNumber(_ people: Int) -> Int {
        let num = people > 6 ? 2 : 1
        return num
    }
}
