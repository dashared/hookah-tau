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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var intervalsStackView: UIStackView!
    
    @IBOutlet weak var saveButton: Button? {
        didSet {
            let style = BlackButtonStyle()
            style.apply(to: saveButton, withTitle: "СОХРАНИТЬ")
        }
    }
    
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
        self.model = model
        
        let (start, _) = model.owner.isAdmin ? model.startTime.getAdminStartingAndEndPoint() : model.startTime.getClientStartingAndEndPoint()
        
        startDate = start
        
        setUpIntervals()
        
        guestSlider?.maximumValue = Float((TotalStorage.standard.getTable(establishment: model.establishment, table: model.reservedTable)?.maxGuestNumber ?? 2) + 1)
    }
    
    func bind(withIntervals intervals: [ReservationPeriod]) {
        guard
            let data = data,
            let isAdmin = model?.owner.isAdmin
        else { return }
        
        setUpReservedIntervals(intervals, isAdmin)
        setUpBookingPeriod(data.startTime, data.endTime)
    }
    
    func updateDateAndTime(withData d: ReservationData?) {
        guard let d = d else { return }
        let (date, time) = Date.format(d.startTime, d.endTime)
        
        dateLabel?.text = date
        timeLabel?.text = time
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        
        if sender.value == sender.maximumValue {
            numberOfGuestLabel?.text = "Количество гостей: \(Int(value) - 1)+"
        } else {
            numberOfGuestLabel?.text = "Количество гостей: \(value)"
        }
        
        guard let d = data else { return }
        
        data = ReservationData(establishment: d.establishment,
                               startTime: d.startTime,
                               endTime: d.endTime,
                               numberOfGuests: value,
                               reservedTable: d.reservedTable)
    }
    
    
    func getNumberOfCalians(_ sliderValue: Int) -> String {
        return "Минимальное количество кальянов: \(sliderValue > 6 ? 2 : 1)"
    }
    
    // MARK: - Setup
    
    /// Тут происходит установка интервалов. Разное для клиента и админа
    func setUpIntervals() {
        guard let startPoint = startDate else { return }
        
        let startingPoint = startPoint.getAdminsStartingPoint()
        let endingPoint = Constants.adminDuration
        
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
        guard let startDate = startDate, let d = data else { return }
        
        let offset = Int(constraint.constant) % Constants.widthTimePoint
        
        if offset == 0 {
            let p = Int(constraint.constant) / Constants.widthTimePoint
            let time = startDate.addPeriods(p)
            
            switch period {
            case .start:
                data = ReservationData(establishment: d.establishment,
                                       startTime: time,
                                       endTime: d.endTime,
                                       numberOfGuests: d.numberOfGuests,
                                       reservedTable: d.reservedTable)
            case .end:
                data = ReservationData(establishment: d.establishment,
                                       startTime: d.startTime,
                                       endTime: time,
                                       numberOfGuests: d.numberOfGuests,
                                       reservedTable: d.reservedTable)
            }
            
            updateDateAndTime(withData: data)
        }
    }
}

// MARK: - Nested types

extension AdminReservationView {
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
