//
//  SecondStepView.swift
//  Hookah Tau
//
//  Created by cstore on 21/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

/// стол, начало, интервалы (???), establishment
struct SecondStepModel {
    var establishment: Int
    var table: Int
    var startTime: Date
    var reservedintervals: [ReservationPeriod]
}

class SecondStepView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet weak var totalBookingLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var numberOfGuestsLabel: UILabel!
    
    @IBOutlet weak var guestSlider: UISlider!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var intervalsStackView: UIStackView!
    
    var data: ReservationData? {
        didSet {
            guard let d = data else { return }
            let (date, time) = Date.format(d.startTime, d.endTime)
            totalBookingLabel.text = "Забронировать \(d.reservedTable) столик на \(d.numberOfGuests) человека \(date) \(time)?"
        }
    }
    
    var model: SecondStepModel? {
        didSet {
            guard let model = model else { return }
            
            data = ReservationData(establishment: model.establishment,
                                   startTime: model.startTime,
                                   endTime: model.startTime.addHours(2),
                                   numberOfGuests: Int(guestSlider.value),
                                   reservedTable: model.table)

            setUpIntervals(model.startTime)
            setUpReservedIntervals(model.reservedintervals)
            setUpBookingPeriod(model.startTime)
        }
    }
    
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
       view.image = #imageLiteral(resourceName: "fff")
       view.translatesAutoresizingMaskIntoConstraints = false
       return view
    }()
    
    var fillInterval: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.5921568627, blue: 1, alpha: 0.3426262843)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var duration: Int? = 1
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.delegate = self
        
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        numberOfGuestsLabel.text = "Количество гостей: \(value)"
        infoLabel.text = getNumberOfCalians(value)
        
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
    
    func setUpIntervals(_ stTime: Date) {
        let isAdmin = DataStorage.standard.getUserModel()?.isAdmin ?? false
        
        let (startPoint, _) = isAdmin ? stTime.getAdminStartingAndEndPoint() : stTime.getClientStartingAndEndPoint()
        
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
    
    
    
    private func setUpBookingPeriod(_ startTime: Date) {
        self.scrollView.addSubview(startPoint)
        self.scrollView.addSubview(endPoint)
        self.scrollView.addSubview(fillInterval)
        
        let startDate = startTime.set(hours: 12, minutes: 0, seconds: 0)!// for client
        
        let startConstr = CGFloat(startTime.getMinutesPeriods(fromStart: startDate) * Constants.timepointWidth)
        
        scrollView.setContentOffset(CGPoint(x: startConstr - 50, y: 0), animated: true)
        
        startLeadingConstraint = startPoint.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                                                  constant: startConstr)
        
        endLeadingConstraint = endPoint.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                                              constant:startConstr + CGFloat(10 * Constants.timepointWidth))
        
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
    
    func setUpReservedIntervals(_ reservations: [ReservationPeriod]) {
        
    }

    func bind(model: SecondStepModel) {
        self.model = model
        
        guard let table = TotalStorage.standard.getTable(establishment: model.establishment,
                                                         table: model.table) else { return }
        self.guestSlider.maximumValue = Float(table.maxGuestNumber)
    }
    
    // MARK: - Pan
    
    @objc func handlePanStart(recognizer:UIPanGestureRecognizer) {
        guard let d = data else { return }
        
          let translation = recognizer.translation(in: self.intervalsStackView)
          if let view = recognizer.view {
            startLeadingConstraint.constant += translation.x
            
            let offset = Int(startLeadingConstraint.constant) % Constants.timepointWidth
            if offset == 0 {
                
                let startDate = d.startTime.set(hours: 12, minutes: 0, seconds: 0)!// for client
                let p = Int(startLeadingConstraint.constant) / Constants.timepointWidth
                let start = startDate.addPeriods(p)
                
                data = ReservationData(establishment: d.establishment,
                                       startTime: start,
                                       endTime: d.endTime,
                                       numberOfGuests: d.numberOfGuests,
                                       reservedTable: d.reservedTable)
            }
            
            view.setNeedsUpdateConstraints()
          }
        
        
          recognizer.setTranslation(CGPoint.zero, in: self.intervalsStackView)
    }
    
    @objc func handlePanEnd(recognizer:UIPanGestureRecognizer) {
        guard let d = data else { return }
        
          let translation = recognizer.translation(in: self.intervalsStackView)
          if let view = recognizer.view {
            endLeadingConstraint.constant += translation.x
            
            let offset = Int(endLeadingConstraint.constant) % Constants.timepointWidth
            if offset == 0 {
                let startDate = d.startTime.set(hours: 12, minutes: 0, seconds: 0)!// for client
                let p = Int(endLeadingConstraint.constant) / Constants.timepointWidth
                let end = startDate.addPeriods(p)
                
                data = ReservationData(establishment: d.establishment,
                                       startTime: d.startTime,
                                       endTime: end,
                                       numberOfGuests: d.numberOfGuests,
                                       reservedTable: d.reservedTable)
            }
            
            view.setNeedsUpdateConstraints()
          }
            
          recognizer.setTranslation(CGPoint.zero, in: self.intervalsStackView)
    }
}

extension SecondStepView: UIScrollViewDelegate {
    
}

// MARK: - Nested types

extension SecondStepView {
    enum Constants {
        static let timepointWidth = 11
        
        static let adminDuration = 288
        static let clientDuration = 90
        // 12:00 = 12 * 6
        static let clientStartingPoint = 72
        
        static let pointWidth: CGFloat = 19
        static let pointHeight: CGFloat = 86
    }
}
