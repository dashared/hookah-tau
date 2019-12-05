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
    
    // MARK: - IBAOutlets
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var closeButton: Button! {
        didSet {
            let style = BlackButtonStyle()
            style.apply(to: closeButton, withTitle: "ЗАКРЫТЬ")
        }
    }
    
    @IBOutlet weak var timeInterval: UIView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    
    /// Время начала вертелки.
    var startDate: Date?
    
    // констрейнты начала и конца интервала
    var startLeadingConstraint: NSLayoutConstraint!
    var endLeadingConstraint: NSLayoutConstraint!
    
    var reservation: Reservation? {
        didSet {
            // isAdmin
            let isAdmin = DataStorage.standard.getUserModel()?.isAdmin ?? false
            startDate = reservation?.startTime.addHours(-1)
            
            setupStackView(isAdmin)
            setUpBookingPeriod() 
        }
    }
    
    // MARK: - bind
    
    func bind(withModel model: Reservation) {
        reservation = model
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
    
    var startPoint: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var endPoint: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2901960784, green: 0.5647058824, blue: 0.8862745098, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Интервал
    var fillInterval: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.5921568627, blue: 1, alpha: 0.3426262843)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupStackView(_ isAdmin: Bool) {
        guard let startPoint = startDate else { return }
        
        let startingPoint = startPoint.getAdminsStartingPoint()
        let endingPoint = startingPoint + (isAdmin ? Constants.adminDuration : Constants.clientDuration)
        
        for period in startingPoint...endingPoint {
            let timePointView = TimePointView.loadFromNib()
            timePointView?.setUp(withTimePoint: period)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 106))
            view.addSubviewThatFills(timePointView)
            stackView.addArrangedSubview(view)
        }
    }
    
    func setUpBookingPeriod() {
        self.scrollView.addSubview(startPoint)
        self.scrollView.addSubview(endPoint)
        self.scrollView.addSubview(fillInterval)
        
        guard
            let startDate = startDate,
            let startTime = reservation?.startTime,
            let endTime = reservation?.endTime else { return }
        
        let startConstr = CGFloat(startTime.getMinutesPeriods(fromStart: startDate) * Constants.widthTimePoint) + 3
        startLeadingConstraint = startPoint.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                                                  constant: startConstr)
        
        let endConstr = CGFloat(endTime.getMinutesPeriods(fromStart: startDate) * Constants.widthTimePoint) + 3
        endLeadingConstraint = endPoint.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                                              constant: endConstr)
        
        scrollView.setContentOffset(CGPoint(x: startConstr - 50, y: 0), animated: true)
        
        NSLayoutConstraint.activate([
            
            startPoint.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            endPoint.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            
            startPoint.widthAnchor.constraint(equalToConstant: Constants.pointWidth),
            endPoint.widthAnchor.constraint(equalToConstant: Constants.pointWidth),
            
            startPoint.heightAnchor.constraint(equalToConstant: Constants.pointHeight),
            endPoint.heightAnchor.constraint(equalToConstant: Constants.pointHeight),
            
            startLeadingConstraint,
            endLeadingConstraint,
            
            fillInterval.leftAnchor.constraint(equalTo: startPoint.rightAnchor, constant: 0),
            fillInterval.rightAnchor.constraint(equalTo: endPoint.leftAnchor, constant: 0),
            
            fillInterval.heightAnchor.constraint(equalToConstant: Constants.pointHeight),
            fillInterval.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
        ])
    }
}

extension ThirdStepView {
    enum Constants {
        static let widthTimePoint = 11
        static let pointWidth: CGFloat = 5
        static let pointHeight: CGFloat = 85
        
        static let adminDuration = 288
        static let clientDuration = 90
        // 12:00 = 12 * 6
        static let clientStartingPoint = 72
    }
}
