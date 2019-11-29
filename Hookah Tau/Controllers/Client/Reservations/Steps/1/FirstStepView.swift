//
//  FirstStepView.swift
//  Hookah Tau
//
//  Created by cstore on 15/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

protocol MapUpdater: class {
    func update(_ date: Date)
}

class FirstStepView: UIView {
    
    weak var mapUpdater: MapUpdater?
    
    var chosenPoint: Int? {
        didSet {
            guard
                let periods = chosenPoint,
                let dateInt = date,
                let newDate = Date.getDateFromCurrent(days: dateInt, periods: periods)
            else { return }
            fullDate = newDate
        }
    }
    
    var fullDate: Date? {
        didSet {
            guard let date = fullDate, let _ = chosenPoint else { return }
            
            let (prev, curr, next) = date.getPrevCurrentNextMonth()
            setupMonth(prev, curr, next)
            
            mapUpdater?.update(date)
        }
    }
    
    var date: Int? {
        didSet {
            guard
                let dateInt = date,
                let periods = chosenPoint,
                let newDate = Date.getDateFromCurrent(days: dateInt, periods: periods)
            else { return }
            fullDate = newDate
            
            guard
                let date = fullDate?.getDMY()
            else { return }
            setUpBookingsForIntervals(reservations: bookingsForDates[date] ?? [])
        }
    }
    
    var bookingsForDates: [Date: [ReservationPeriod]] = [:] {
        didSet {
            guard
                let date = fullDate?.getDMY()
            else { return }
            
            setUpBookingsForIntervals(reservations: bookingsForDates[date] ?? [])
        }
    }
    
    // intervals

    @IBOutlet weak var scrollViewIntervals: UIScrollView!
    
    @IBOutlet weak var stackViewIntervals: UIStackView!
    
    // dates
    
    @IBOutlet weak var datesStackView: UIStackView!
    
    @IBOutlet weak var datesScrollView: UIScrollView!
    
    // note labels
    
    @IBOutlet weak var earlierThan12Label: UILabel!
    
    @IBOutlet weak var laterThan3Label: UILabel!
    
    // months
    
    @IBOutlet weak var previousMonthLabel: UILabel!
    
    @IBOutlet weak var currentMonthLabel: UILabel!
    
    @IBOutlet weak var nextMonthLabel: UILabel!
    
    
    
    var bookingsViewsForDate: [UIView] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollViewIntervals.delegate = self
        datesScrollView.delegate = self
        
        scrollViewIntervals.showsHorizontalScrollIndicator = false
        datesScrollView.showsHorizontalScrollIndicator = false
        
        setUpDateStackView()
        setUpIntervalStackView()
    }
    
    func setUpIntervalStackView() {
        
        for period in 0...Constants.day10MinPeriods {
            let timePointView = TimePointView.loadFromNib()
            timePointView?.setUp(withTimePoint: period)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 92))
            view.addSubviewThatFills(timePointView)
            stackViewIntervals.addArrangedSubview(view)
        }
    }
    
    func setUpBookingsForIntervals(reservations: [ReservationPeriod]) {
        bookingsViewsForDate.forEach { $0.removeFromSuperview() }
        bookingsViewsForDate = []
        
        for reservation in reservations {
            let uiview = UIView(frame: CGRect(x: 0, y: 0, width: Constants.widthTimePoint * reservation.duration, height: Constants.heightIntervals))
            uiview.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
            
            
            uiview.translatesAutoresizingMaskIntoConstraints = false
            scrollViewIntervals.addSubview(uiview)
            
            guard let date = date else { return }
            let startDate = Date.getDateFromCurrent(days: date)!.set(hours: 12, minutes: 0, seconds: 0)!
            
            NSLayoutConstraint.activate([
                uiview.bottomAnchor.constraint(equalToSystemSpacingBelow: scrollViewIntervals.bottomAnchor, multiplier: 0),
                uiview.leftAnchor.constraint(equalTo: scrollViewIntervals.leftAnchor,
                                             constant: CGFloat(Constants.widthTimePoint / 2 + Constants.widthTimePoint * reservation.startTime.getMinutesPeriods(fromStart: startDate))),
                uiview.widthAnchor.constraint(equalToConstant: CGFloat(Constants.widthTimePoint * reservation.duration)),
                uiview.heightAnchor.constraint(equalToConstant: CGFloat(Constants.heightIntervals))
            ])
            
            bookingsViewsForDate.append(uiview)
        }
    }
    
    func setContent() {
        scrollViewIntervals.contentSize = stackViewIntervals.frame.size
        datesScrollView.contentSize = datesStackView.frame.size
        
        let halfWidth = frame.size.width / 2
        let edges = UIEdgeInsets(top: 0, left: halfWidth, bottom: 0, right: halfWidth)
        
        scrollViewIntervals.contentInset = edges
        datesScrollView.contentInset = edges
        
        datesScrollView.setContentOffset(CGPoint(x: abs(Constants.widthDate * Constants.daysCount / 2 - Int(edges.left)) + 8, y: 0),
                                         animated: true)
        scrollViewIntervals.setContentOffset(CGPoint(x: abs(Constants.widthTimePoint * Constants.day10MinPeriods / 2 - Int(edges.left)) + 5, y: 0),
                                             animated: true)
    }
    
    
    /// Method for setting up `stackViewIntervals` with appropriate busy intervals of chosen table
    /// - Parameter data: Map of booked periods by key - date - is provided
    func setUp(_ data: [Date: [ReservationPeriod]]) {
        bookingsForDates = data
    }
    
    func setUpDateStackView() {
        let dates = Date.getNext(days: Constants.daysCount)
        
        for date in dates {
            let dateView = DateView.loadFromNib()
            dateView?.setUp(with: date)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 21, height: 59))
            view.addSubviewThatFills(dateView)
            datesStackView.addArrangedSubview(view)
        }
    }
    
    func setupMonth(_ prev: String, _ curr: String, _ next: String) {
        currentMonthLabel.text = curr
        previousMonthLabel.text = prev
        nextMonthLabel.text = next
    }
}

extension FirstStepView: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == scrollViewIntervals {
            intervalsDidScroll()
        } else {
            datesDidScroll()
        }
    }
    
    func intervalsDidScroll() {
        let inset = scrollViewIntervals.contentInset.left
        let alpha12 = 1 / (abs(inset + scrollViewIntervals.contentOffset.x) / inset)
        let alpha3 = 1 / (abs(inset + scrollViewIntervals.contentOffset.x - stackViewIntervals.frame.width) / inset)
        
        earlierThan12Label.textColor = earlierThan12Label.textColor.withAlphaComponent(alpha12)
        laterThan3Label.textColor = laterThan3Label.textColor.withAlphaComponent(alpha3)
        
        for (index, stack) in stackViewIntervals.subviews.enumerated() {
            if let intervalStack = stack.subviews[0] as? TimePointView  {
                let positionToSelf = intervalStack.convert(intervalStack.frame, to: self)
                
                if abs((positionToSelf.minX + positionToSelf.maxX) / 2 - frame.size.width / 2) < 5.5
                {
                    intervalStack.timePoint.backgroundColor = .darkGray
                    chosenPoint = index
                } else {
                    intervalStack.timePoint.backgroundColor = .lightGray
                }
            }
        }
    }
    
    func datesDidScroll() {
        for (_, stack) in datesStackView.subviews.enumerated() {
            if let dateView = stack.subviews[0] as? DateView {
                let positionToSelf = dateView.convert(dateView.frame, to: self)
                
                if abs((positionToSelf.minX + positionToSelf.maxX) / 2  - frame.size.width / 2) < 15.5 {
                    dateView.dateLabel.textColor = .black
                    date = Int(datesScrollView.contentInset.left + datesScrollView.contentOffset.x) / 31
                } else {
                    dateView.dateLabel.textColor = .lightGray
                }
            }
        }
    }
}

// MARK: - Nested types

extension FirstStepView {
    enum Constants {
        static let day10MinPeriods = 90
        static let daysCount = 14
        static let widthTimePoint = 11
        static let widthDate = 31
        static let heightIntervals = 70
    }
}
