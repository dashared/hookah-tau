//
//  IntervalPickerView.swift
//  Hookah Tau
//
//  Created by cstore on 19/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

struct IntervalPickerModel {
    var startTime: Date
    var endTime: Date
}

protocol PickerViewUpdater: class {
    func update(withModel model: IntervalPickerModel)
}

class IntervalPickerView: UIView {

    // MARK: - IBAOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var intervalsStackView: UIStackView!
    
    // MARK: - Properties
    
    // констрейнты начала и конца интервала
    var startLeadingConstraint: NSLayoutConstraint!
    var endLeadingConstraint: NSLayoutConstraint!
    
    var startPoint: UIImageView = {
        var view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = #imageLiteral(resourceName: "handle_left")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var endPoint: UIImageView = {
       var view = UIImageView()
       view.isUserInteractionEnabled = true
       view.image = #imageLiteral(resourceName: "Group")
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
    
    /// Время начала вертелки.
    /// Для клиента это 12:00 смены (надо вызвать метод для получения текущей смены).
    /// Для администратора это `t`  - 24h
    var startDate: Date?
    
    /// Моделька для смены промежутков
    var model: IntervalPickerModel? {
        didSet {
            guard let model = model else { return }
            updater?.update(withModel: model)
        }
    }
    
    weak var updater: PickerViewUpdater?
    
    // MARK: - bind

    func bind(withModel model: ReservationData, user isAdmin: Bool, intervals: [ReservationPeriod]) {
        // isAdmin
        let isAdmin = DataStorage.standard.getUserModel()?.isAdmin ?? false
        
        let (start, _) = isAdmin ? model.startTime.getAdminStartingAndEndPoint() : model.startTime.getClientStartingAndEndPoint()
        
        startDate = start
        
        setUpIntervals(isAdmin)
        setUpReservedIntervals(intervals, isAdmin)
        setUpBookingPeriod(model.startTime, model.endTime)
    }
    
    /// Тут происходит установка интервалов. Разное для клиента и админа
    func setUpIntervals(_ isAdmin: Bool) {
        guard let startPoint = startDate else { return }
        
        let startingPoint = isAdmin ? startPoint.getAdminsStartingPoint() : Constants.clientStartingPoint
        let endingPoint = startingPoint + (isAdmin ? Constants.adminDuration : Constants.clientDuration)
        
        for period in startingPoint...endingPoint {
            let timePointView = TimePointView.loadFromNib()
            timePointView?.setUp(withTimePoint: period)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 106))
            view.addSubviewThatFills(timePointView)
            intervalsStackView.addArrangedSubview(view)
        }
    }
    
    private func setUpBookingPeriod(_ startTime: Date, _ endTime: Date? = nil) {
        self.scrollView.addSubview(startPoint)
        self.scrollView.addSubview(endPoint)
        self.scrollView.addSubview(fillInterval)
        
        guard let startDate = startDate else { return }
        
        let startConstr = CGFloat(startTime.getMinutesPeriods(fromStart: startDate) * Constants.widthTimePoint)
        
        scrollView.setContentOffset(CGPoint(x: startConstr - 50, y: 0), animated: true)
        
        startLeadingConstraint = startPoint.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                                                  constant: startConstr)
        
        if let end = endTime {
            let endConstr = CGFloat(end.getMinutesPeriods(fromStart: startDate) * Constants.widthTimePoint)
            endLeadingConstraint = endPoint.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                                                  constant: endConstr)
        } else {
            endLeadingConstraint = endPoint.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                                                  constant:startConstr + Constants.minBookingLength)
        }
        
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
        
        let scrollViewPanStartGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanStart(recognizer:)))
        startPoint.addGestureRecognizer(scrollViewPanStartGesture)
        
        let scrollViewPanEndGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanEnd(recognizer:)))
        endPoint.addGestureRecognizer(scrollViewPanEndGesture)
    }
    
    func setUpReservedIntervals(_ reservations: [ReservationPeriod], _ isAdmin: Bool) {

        for reservation in reservations {
            let uiview = UIView(frame: CGRect(x: 0, y: 0, width: Constants.widthTimePoint * reservation.duration, height: Constants.heightIntervals))
            uiview.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
            
            
            uiview.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(uiview)
        
            guard let startDate = startDate else { return }
            
            let s = reservation.startTime.getMinutesPeriods(fromStart: startDate) * Constants.widthTimePoint
            let d = reservation.duration * Constants.widthTimePoint
            
            let startTime = s < 0 ? 0 : s
            
            let total = (isAdmin ? Constants.adminDuration : Constants.clientDuration) * Constants.widthTimePoint
            var duration = 0
            if s < 0 {
                duration = reservation.endTime.getMinutesPeriods(fromStart: startDate) * Constants.widthTimePoint
            } else {
                duration = (s + d) > total ? total - s : d
            }
                
            NSLayoutConstraint.activate([
                uiview.bottomAnchor.constraint(equalToSystemSpacingBelow: scrollView.bottomAnchor, multiplier: 0),
                uiview.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                             constant: CGFloat(Constants.widthTimePoint / 2 + startTime)),
                uiview.widthAnchor.constraint(equalToConstant: CGFloat(duration)),
                uiview.heightAnchor.constraint(equalToConstant: CGFloat(Constants.heightIntervals))
            ])
        }
    }
    
    // MARK: - Pan
    
    @objc func handlePanStart(recognizer:UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.intervalsStackView)
        let duration = abs(startLeadingConstraint.constant + translation.x - endLeadingConstraint.constant)
        
          if let view = recognizer.view, duration >= Constants.minBookingLength {
            startLeadingConstraint.constant += translation.x
            
            changeTime(startLeadingConstraint, .start)
            
            view.setNeedsUpdateConstraints()
          }
        
        recognizer.setTranslation(CGPoint.zero, in: self.intervalsStackView)
    }
    
    @objc func handlePanEnd(recognizer:UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.intervalsStackView)
        let duration = abs(startLeadingConstraint.constant - (endLeadingConstraint.constant + translation.x))

        if let view = recognizer.view, duration >= Constants.minBookingLength {
            endLeadingConstraint.constant += translation.x
            
            changeTime(endLeadingConstraint, .end)
            view.setNeedsUpdateConstraints()
        }
            
        recognizer.setTranslation(CGPoint.zero, in: self.intervalsStackView)
    }
    
    func changeTime(_ constraint: NSLayoutConstraint, _ period: Period) {
        guard let startDate = startDate, let m = model else { return }
        
        let offset = Int(constraint.constant) % Constants.widthTimePoint
        
        if offset == 0 {
            let p = Int(constraint.constant) / Constants.widthTimePoint
            let time = startDate.addPeriods(p)
            
            switch period {
            case .start:
                model = IntervalPickerModel(startTime: time,
                                            endTime: m.endTime)
            case .end:
                model = IntervalPickerModel(startTime: m.startTime,
                                            endTime: time)
            }
        }
    }
}

extension IntervalPickerView {
    enum Constants {
        static let widthTimePoint = 11
        
        static let adminDuration = 288
        static let clientDuration = 90
        // 12:00 = 12 * 6
        static let clientStartingPoint = 72
        
        static let pointWidth: CGFloat = 19
        static let pointHeight: CGFloat = 85
        
        static let minBookingLength: CGFloat = 132
        
        static let heightIntervals = 85
    }
    
    enum Period {
        case start
        case end
    }
}
