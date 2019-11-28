//
//  SecondStepView.swift
//  Hookah Tau
//
//  Created by cstore on 21/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

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
    
    var model: SecondStepModel? {
        didSet {
            guard let model = model else { return }
            totalBookingLabel.text = "Забронировать \(model.table) столик на \(Int(guestSlider.value)) человека \(model.startTime)?"
            
            setUpReservedIntervals(model.reservedintervals)
            setUpBookingPeriod(model.startTime)
        }
    }
    
    var startLeadingConstraint: NSLayoutConstraint!
    var endLeadingConstraint: NSLayoutConstraint!
    
    var startPoint: UIView = {
        var view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var endPoint: UIView = {
        var view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var fillInterval: UIView = {
        var view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 0.604880137)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var duration: Int? = 1
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.delegate = self
        
        scrollView.showsHorizontalScrollIndicator = false
        
        setUpIntervals()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        numberOfGuestsLabel.text = "Количество гостей: \(value)"
        infoLabel.text = getNumberOfCalians(value)
        totalBookingLabel.text = "Забронировать \(model?.table ?? 0) столик на \(value) человека 29 марта с 3:00 до 5:30?"
    }
    
    func getNumberOfCalians(_ sliderValue: Int) -> String {
        return "Минимальное количество кальянов: \(sliderValue > 6 ? 2 : 1)"
    }
    
    // MARK: - Setup
    
    func setUpIntervals() {
        for period in 0...Constants.day10MinPeriods {
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
        
        let startDate = startTime.set(hours: 12, minutes: 0, seconds: 0)!
        
        let startConstr = CGFloat(startDate.getMinutesPeriods(fromStart: startTime) * Constants.timepointWidth)
        
        scrollView.setContentOffset(CGPoint(x: startConstr, y: 0), animated: true)
        
        startLeadingConstraint = startPoint.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                                                  constant: startConstr)
        endLeadingConstraint = endPoint.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                                              constant:startConstr + CGFloat(10 * Constants.timepointWidth))
        
        NSLayoutConstraint.activate([
            startPoint.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            endPoint.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            
            startPoint.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            endPoint.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            
            startPoint.widthAnchor.constraint(equalToConstant: 7),
            endPoint.widthAnchor.constraint(equalToConstant: 7),
            
            startLeadingConstraint,
            endLeadingConstraint,
            
            fillInterval.leftAnchor.constraint(equalTo: startPoint.rightAnchor, constant: 0),
            fillInterval.rightAnchor.constraint(equalTo: endPoint.leftAnchor, constant: 0),
            
            fillInterval.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
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
          let translation = recognizer.translation(in: self.intervalsStackView)
          if let view = recognizer.view {
            startLeadingConstraint.constant += translation.x
            view.setNeedsUpdateConstraints()
          }
            
          recognizer.setTranslation(CGPoint.zero, in: self.intervalsStackView)
    }
    
    @objc func handlePanEnd(recognizer:UIPanGestureRecognizer) {
          let translation = recognizer.translation(in: self.intervalsStackView)
          if let view = recognizer.view {
            endLeadingConstraint.constant += translation.x
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
        static let day10MinPeriods = 90
        static let timepointWidth = 11
    }
}
