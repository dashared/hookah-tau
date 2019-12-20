//
//  ChangeReservationViewController.swift
//  Hookah Tau
//
//  Created by cstore on 02/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ChangeReservationViewController: BaseViewController {
    
    // MARK: - IBAOutlets
    
    @IBOutlet weak var childContentView: UIView!
    
    @IBOutlet weak var mapContentView: UIView!
    
    // MARK: - Peoperties
    
    var reservation: Reservation?
    
    var secondStepView: SecondStepView?
    
    var mapView: MapImageScroll?
    
    /// Как только получили ответ на запросах о бронирвоаниях, сразу обновляем
    var reservedIntervals: [ReservationPeriod] = [] {
        didSet {
            setupContainer(withReservedPeriods: reservedIntervals)
        }
    }
    
    var reservationService: ReservationsService?
    
    weak var coordinator: ChangeReservationCoordinator?
    
    // MARK: - Buttons
    
    var confirmButton: Button = {
        var button = Button()
        var style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ПОДТВЕРДИТЬ")
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reservationService = ReservationsService(apiClient: APIClient.shared)
        setupButtons()
        setupMap()
        getReservations()
        
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    
    // MARK: - setup
    
    func setupButtons() {
       addStackViewWithButtons( rightBtn: confirmButton,
                                constant: -childContentView.frame.height - 20)
        
        confirmButton.addTarget(self, action: #selector(changeReservation), for: .touchUpInside)
    }
    
    func setupContainer(withReservedPeriods resPer: [ReservationPeriod]) {
        secondStepView = SecondStepView.loadFromNib()
        childContentView.addSubviewThatFills(secondStepView)
        
        guard let r = reservation else { return }
        
        secondStepView?.bind(model: SecondStepModel(establishment: r.establishment,
                                                    table: r.reservedTable,
                                                    startTime: r.startTime,
                                                    endTime: r.endTime,
                                                    reservedintervals: resPer))
    }
    
    func getReservations() {
        guard let r = reservation else { return }
        reservationService?.getAllReservations(establishmentID: r.establishment, completion: { (res) in
            switch res {
            case .failure(let err):
                self.displayAlert(forError: err, with: "Прости, не смогли загрузить доступные периоды для брони этого столика. Попробуй, пожалуйста, еще раз!")
            case .success(let allReservations):
                let isAdmin = DataStorage.standard.getUserModel()?.isAdmin ?? false
                let (start, end) = isAdmin ? r.startTime.getAdminStartingAndEndPoint() : r.startTime.getClientStartingAndEndPoint()
                let reservPeriods = HFunc.main.filterPeriodsStartEndDates(allReservations.reservations[r.reservedTable] ?? [],
                                                                          start,
                                                                          end)
                
                self.reservedIntervals = reservPeriods
            }
        })
    }
    
    func setupMap() {
        guard let reservation = reservation else {
            return
        }
        
        let width = view.frame.width
        if reservation.establishment == 1 {
            mapView = MapView1.loadFromNib()
            mapView?.scrollViewParent.contentInset = UIEdgeInsets(top: 0,
                                                                  left: width / 2,
                                                                  bottom: 200,
                                                                  right: width / 2)

            mapView?.scrollViewParent.setContentOffset(CGPoint(x: 0, y: 50), animated: false)
        } else {
            mapView = MapView2.loadFromNib()
            mapView?.scrollViewParent.setContentOffset(CGPoint(x: 0, y: -100), animated: false)
            mapView?.scrollViewParent.contentInset = UIEdgeInsets(top: 100,
                                                                  left: width / 2,
                                                                  bottom: 100,
                                                                  right: width / 2)
        }
        
        mapContentView.addSubviewThatFills(mapView)
        
        mapView?.isUserInteractionEnabled = false
        mapView?.scrollToTable(table: reservation.reservedTable)
    }
    
    // MARK: - Handlers
    
    @objc func changeReservation() {
        guard let r = secondStepView?.data, let uuid = reservation?.uuid else { return }
        confirmButton.loading = true
        
        reservationService?.updateReservation(startTime: r.startTime,
                                              numberOfGuests: r.numberOfGuests,
                                              endTime: r.endTime,
                                              uuid: uuid,
                                              isAdmin: false,
                                              completion: { [weak self] (res) in
                                                if res {
                                                    self?.coordinator?.finish(Reservation(uuid: uuid, reservationData: r))
                                                } else {
                                                    self?.displayAlert(with: "Что-то пошло не так! Попробуешь еще раз?")
                                                }
                                                
                                                self?.confirmButton.loading = false
        })
    }

}
