//
//  FirstStepView.swift
//  Hookah Tau
//
//  Created by cstore on 15/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

protocol MapUpdater: class {
    func update(_ date: IntervalDate)
}

class FirstStepView: UIView {
    
    weak var mapUpdater: MapUpdater?
    
    var chosenPoint: Int? = 0 {
        didSet {
            guard let point = chosenPoint, let date = chosenDate else { return }
            let newIntervalDate = IntervalDate(day: date.day,
                                               month: date.month,
                                               year: date.year,
                                               minutes: point)
            mapUpdater?.update(newIntervalDate)
        }
    }
    
    var chosenDate: IntervalDate? = Date.getDateFromCurrent() {
        didSet {
            guard let date = chosenDate, let _ = chosenPoint else { return }
            mapUpdater?.update(date)
        }
    }

    @IBOutlet weak var scrollViewIntervals: UIScrollView!
    
    @IBOutlet weak var stackViewIntervals: UIStackView!
    
    @IBOutlet weak var datesStackView: UIStackView!
    
    @IBOutlet weak var datesScrollView: UIScrollView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollViewIntervals.delegate = self
        self.datesScrollView.delegate = self
        
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
    
    func addBusyPeriods() {
        
    }
    
    func setContent() {
        scrollViewIntervals.contentSize = stackViewIntervals.frame.size
        datesScrollView.contentSize = datesStackView.frame.size
        
        let edges = UIEdgeInsets(top: 0, left: self.frame.size.width / 2, bottom: 0, right: self.frame.size.width / 2)
        scrollViewIntervals.contentInset = edges
        datesScrollView.contentInset = edges
        
        datesScrollView.setContentOffset(CGPoint(x: abs(Constants.widthDate * Constants.daysCount / 2 - Int(edges.left)), y: 0), animated: true)
        scrollViewIntervals.setContentOffset(CGPoint(x: abs(Constants.widthTimePoint * Constants.day10MinPeriods / 2 - Int(edges.left)), y: 0), animated: true)
    }
    
    func setUp(_ data: AllReservations) {
        //let sortedDates = data.intervals.keys.sorted()
        
        // setUpDateStackView()
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
        for (index, stack) in stackViewIntervals.subviews.enumerated() {
            if let intervalStack = stack.subviews[0] as? TimePointView  {
                let positionToSelf = intervalStack.convert(intervalStack.frame, to: self)
            
//                var isBusy = false
//                let positionToScrollView = intervalStack.convert(intervalStack.frame, to: self.scrollViewIntervals)
                
//                for busyView in busyViews {
//                    if busyView.frame.contains(positionToScrollView) {
//                        isBusy = true
//                    }
//                }
                
                if abs((positionToSelf.minX + positionToSelf.maxX) / 2 - frame.size.width / 2) < 5.5
                    //,!isBusy
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
                    chosenDate = Date.getDateFromCurrent(days: Int((datesScrollView.contentInset.left + datesScrollView.contentOffset.x) / 31), period: chosenPoint)
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
    }
}
