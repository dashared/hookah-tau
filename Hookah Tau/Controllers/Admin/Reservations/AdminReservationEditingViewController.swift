//
//  AdminReservationEditingViewController.swift
//  Hookah Tau
//
//  Created by cstore on 20/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminReservationEditingViewController: BaseViewController {
    
    // MARK:- IBAOutlets
    
    @IBOutlet weak var tableContentView: UIView!
    
    @IBOutlet weak var mainContentView: UIView!
    
    // MARK:- Properties
    
    var mapView: MapImageScroll?
    
    var reservationView: AdminReservationView?
    
    var reservationData: ReservationWithUser?
    
    weak var coordinator: ShowReservationCoordinator?
    
    var reservationService: ReservationsService?
    
    var reservedPeriods: [ReservationPeriod] = [] {
        didSet {
            if let _ = reservationView {
                setupReservationViewWithIntervals()
            }
        }
    }

    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupContentViews()
        
        reservationService = ReservationsService(apiClient: APIClient.shared)
        
        loadReservedPeriods()
        
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Setup
    
    func setupButtons() {
        
        reservationView?.saveButton?.addTarget(self, action: #selector(saveReservation), for: .touchUpInside)
        reservationView?.cancelButton?.addTarget(self, action: #selector(cancelReservation), for: .touchUpInside)
    }

    func setupContentViews() {
        guard
            let model = reservationData
            else { return }
        
        if model.establishment == 1 {
            mapView = MapView1.loadFromNib()
        } else {
            mapView = MapView2.loadFromNib()
        }
        
        navigationItem.title = TotalStorage.standard.getEstablishment(model.establishment)?.address
    
        mapView?.isUserInteractionEnabled = false
        
        tableContentView.addSubviewThatFills(mapView)
        mapView?.scrollToTable(table: model.reservedTable)
        
        reservationView = AdminReservationView.loadFromNib()
        reservationView?.bind(withModel: model)
        
        mainContentView.addSubviewThatFills(reservationView)
    }
    
    func setupReservationViewWithIntervals() {
        reservationView?.bind(withIntervals: reservedPeriods)
    }
    
    func loadReservedPeriods() {
        guard
            let model = reservationData,
            let uuid = model.uuid
        else {
                setupReservationViewWithIntervals()
                return }
        
        reservationService?.getReservationsAround(uuid: uuid, completion: { [weak self] (res) in
            switch res {
            case .failure(let err):
                self?.displayAlert(forError: err)
                return
            case .success(let reserv):
                self?.reservedPeriods = reserv
                return
            }
        })
    }
    
    // MARK:- Handlers
    
    @objc func saveReservation() {
        guard
            let r = reservationView?.data,
            let uuid = reservationData?.uuid
            else {
                createReservation()
                return
        }
        
        reservationView?.saveButton?.loading = true
        
        reservationService?.updateReservation(startTime: r.startTime,
                                              numberOfGuests: r.numberOfGuests,
                                              endTime: r.endTime,
                                              uuid: uuid,
                                              isAdmin: true,
                                              completion: { [weak self] (res) in
                                                if res {
                                                    self?.coordinator?.didFinish?()
                                                } else {
                                                    self?.displayAlert(with: "Что-то пошло не так! Попробуешь еще раз?")
                                                }
                                                
                                                self?.reservationView?.saveButton?.loading = false
        })
    }
    
    func createReservation() {
        guard
            let r = reservationData,
            let d = reservationData?.owner.phoneNumber else { return }
        
        let data = ReservationData(establishment: r.establishment,
                                   startTime: r.startTime,
                                   endTime: r.endTime,
                                   numberOfGuests: r.numberOfGuests,
                                   reservedTable: r.reservedTable)
        print(data)
        reservationService?.createReservation(reservation: AdminCreateReservation(reservation: data, user: d), completion: { (res) in
            switch res {
            case .failure(_):
                self.displayAlert(with: "Что-то пошло не так!\nПопробуешь еще раз?")
                return
            case .success(let uuid):
                self.reservationData?.uuid = uuid
                self.coordinator?.didFinish?()
                return
            }
        })
    }
    
    @objc func cancelReservation() {
        guard
            let uuid = reservationData?.uuid
        else {
            cancelPrereservation()
            return }
        
        reservationService?.deleteReservation(isAdmin: true, uuid: uuid, completion: { [weak self] (res) in
            if res {
                self?.coordinator?.didFinish?()
            } else {
                self?.displayAlert(with: "Что-то пошло не так!\nПопробуешь еще раз?")
            }
        })
    }
    
    func cancelPrereservation() {
        coordinator?.didFinish?()
    }
}
