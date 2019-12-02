//
//  ReservationViewController.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class FirstStepReservationViewController: BaseViewController {
    
    // MARK: - Properties
    
    weak var coordinator: FirstStepReservationCoordinator?
    
    @IBOutlet weak var childContentView: UIView!
    
    var firstStepView: FirstStepView?
    
    var tableId: Int = 2
    
    var reservationsService: ReservationsService?
    
    var mapView: MapImageScroll? {
        didSet {
            view.addSubviewThatFills(mapView)
            guard let map = mapView else { return }
            map.scrollViewParent.contentInset = UIEdgeInsets(top: 0,
                                                             left: 0,
                                                             bottom: childContentView.frame.height,
                                                             right: 0)
            map.isUserInteractionEnabled = true
            map.scrollViewParent.setZoomScale(0.5, animated: true)
            map.scrollBack()
            view.sendSubviewToBack(map)
        }
    }
    
    var allReservations: AllReservations? {
        didSet {
            guard let _ = allReservations else {
                return
            }
            
            updateChildViewControllerWithChosenId(tableId)
        }
    }
    
    let continueButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ЗАБРОНИРОВАТЬ")
        return button
    }()
    
    let callButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ПОЗВОНИТЬ")
        return button
    }()
    
    var establishmentId: Int = 1

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        setupChildContainer()
        
        setupButtons()
        
        reservationsService = ReservationsService(apiClient: APIClient.shared)
        
        performUpdate()
        
        navigationItem.title = TotalStorage.standard.getEstablishment(establishmentId)?.address
    }
    
    func setupButtons() {
        addStackViewWithButtons(leftBtn: callButton,
                                rightBtn: continueButton,
                                constant: -childContentView.frame.height - 20)
        
        continueButton.addTarget(self, action: #selector(continueBooking), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(call(phone:)), for: .touchUpInside)
    }
    
    func performUpdate() {
        reservationsService?.getAllReservations(establishmentID: establishmentId, completion: { [weak self] result in
            switch result {
            case .failure(let err):
                self?.displayAlert(forError: err)
            case .success(let allReservations):
                self?.allReservations = allReservations
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        firstStepView?.setContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    func configureMap() {
        if establishmentId == 1 {
            mapView = MapView1.loadFromNib()
        } else if establishmentId == 2 {
            mapView = MapView2.loadFromNib()
        }
        mapView?.handler = self
    }
    
    func setupChildContainer() {
        firstStepView = FirstStepView.loadFromNib()
        firstStepView?.mapUpdater = self
        childContentView.addSubviewThatFills(firstStepView)
    }
    
    func updateChildViewControllerWithChosenId(_ id: Int) {
        let reservationsForTable = allReservations?.reservations[id] ?? []
        firstStepView?.setUp(reservationsForTable)
    }
    
    // MARK: - button handlers
    
    @objc func continueBooking() {
        let map = mapView
        
        guard let startTime = firstStepView?.fullDate else { return }
        
        let reservPeriods = HFunc.main.filterPeriodsInDate(allReservations?.reservations[tableId] ?? [],
                                                           startTime)
        
        let model = SecondStepModel(establishment: establishmentId,
                                    table: tableId,
                                    startTime: startTime,
                                    reservedintervals: reservPeriods)
        
        coordinator?.makeReservation(model: model,
                                     mapView: map)
    }
    
    @objc func call(phone: String) {
        guard
            let phone = TotalStorage.standard.getEstablishment(establishmentId)?.admin,
            let urlPhone = URL(string: "tel://79\(phone)") else { return }
    
        UIApplication.shared.open(urlPhone)
    }
}

extension FirstStepReservationViewController: MapHandler {
    func handleTap(withId id: Int) {
        tableId = id
        updateChildViewControllerWithChosenId(id)
    }
}

extension FirstStepReservationViewController: MapUpdater {
    func update(_ date: Date) {
        let areBooked =  allReservations?.intervals[date] ?? []
        
        if Set(areBooked).contains(tableId) {
            continueButton.availiable = false
        } else {
            continueButton.availiable = true
        }
        
        mapView?.performUpdate(inactive: areBooked)
    }
}
