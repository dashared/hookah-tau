//
//  ThirdStepReservationViewController.swift
//  Hookah Tau
//
//  Created by cstore on 23/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ThirdStepReservationViewController: BaseViewController {
    
    // MARK: - IBAOutlets

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var contentForMap: UIView!
    
    // MARK: - Properties
    
    var mapView: MapImageScroll?
    
    weak var coordinator: ThirdStepReservationCoordinator?
    
    var thirdStepView: ThirdStepView?
    
    var reservation: Reservation? {
        didSet {
            guard let r = reservation,
                let data = TotalStorage.standard.getEstablishment(r.establishment)
                else { return }
            
            navigationItem.title = data.address
        }
    }
    
    var reservationService: ReservationsService?
    
    /// "Отменить бронь"
    let cancelButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ОТМЕНИТЬ БРОНЬ")
        return button
    }()
    
    /// "Изменить бронь"
    let changeButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ИЗМЕНИТЬ")
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        setupContainer()
        setupButtons()
        setupMap()
        
        reservationService = ReservationsService(apiClient: APIClient.shared)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Setup
    
    func setupMap() {
        guard let reservation = reservation else {
            return
        }
        
        if reservation.establishment == 1 {
            mapView = MapView1.loadFromNib()
        } else {
            mapView = MapView2.loadFromNib()
        }
        
        contentForMap.addSubviewThatFills(mapView)
        
        let width = view.frame.width
        mapView?.scrollViewParent.contentInset = UIEdgeInsets(top: 0,
                                                              left: width / 2,
                                                              bottom: 300,
                                                              right: width / 2)
        
        mapView?.scrollViewParent.setContentOffset(CGPoint(x: 0, y: -100), animated: false)
        
        mapView?.isUserInteractionEnabled = false
        mapView?.scrollToTable(table: reservation.reservedTable)
    }
    
    func setupContainer() {
        thirdStepView = ThirdStepView.loadFromNib()
        containerView.addSubviewThatFills(thirdStepView)
        
        guard let res = reservation else { return }
        thirdStepView?.bind(withModel: res)
    }
    
    func setupButtons() {
        addStackViewWithButtons(leftBtn: cancelButton,
                                rightBtn: changeButton,
                                constant: -containerView.frame.height - 20)
        
        changeButton.addTarget(self, action: #selector(change), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelBooking), for: .touchUpInside)
        thirdStepView?.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    
    // MARK: - handlers for buttons
    
    @objc func change() {
        guard
            let res = reservation,
            let map = mapView
            else { return }
        
        coordinator?.change(res, map)
    }
    
    @objc func cancelBooking() {
        guard let res = reservation else { return }
        
        cancelButton.loading = true
        reservationService?.deleteReservation(uuid: res.uuid, completion: { [weak self] (result) in
            self?.cancelButton.loading = false
            
            if result {
                self?.close()
            } else {
                self?.displayAlert(with: "Не удалось отменить бронь, попробуйте еще раз!")
            }
        })
    }
    
    @objc func close() {
        coordinator?.close()
    }
}
