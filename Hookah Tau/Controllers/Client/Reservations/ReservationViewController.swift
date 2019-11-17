//
//  ReservationViewController.swift
//  Hookah Tau
//
//  Created by cstore on 06/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit


class ReservationViewController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var childContentView: UIView!
    
    var firstStepView: FirstStepView?
    
    var reservationsService: ReservationsService?
    
    var mapView: MapImageScroll?
    
    var allReservations: AllReservations? {
        didSet {
            guard let reservations = allReservations else {
                return
            }
            
            self.firstStepView?.setUp(reservations)
        }
    }
    
    let continueButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ЗАБРОНИРОВАТЬ")
        //button.addTarget(self, action: #selector(doneChanging), for: .touchUpInside)
        return button
    }()
    
    let callButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ПОЗВОНИТЬ")
        //button.addTarget(self, action: #selector(cancelChange), for: .touchUpInside)
        return button
    }()
    
    var establishmentId: Int = 1
    var step: Int = 1

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureStep()
        
        addStackViewWithButtons(leftBtn: callButton, rightBtn: continueButton, constant: -childContentView.frame.height - 20)
        reservationsService = ReservationsService(apiClient: APIClient.shared)
        
        performUpdate()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func configureMap() {
        if establishmentId == 1 {
            mapView = MapView1.loadFromNib()
            view.addSubviewThatFills(mapView)
        } else {
            // mapView = MapView2.loadFromNib()
        }
        
        guard let map = mapView else { return }
        map.scrollViewParent.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: childContentView.frame.height, right: 0)
        view.sendSubviewToBack(map)
    }
    
    func configureStep() {
        if step == 1 {
            firstStepView = FirstStepView.loadFromNib()
            firstStepView?.mapUpdater = self
            childContentView.addSubviewThatFills(firstStepView)
        }
    }
    
    func updateChildViewControllerWithChosenId(_ id: Int) {
        print("Chosen \(id) table")
    }
}

extension ReservationViewController: MapHandler {
    func handleTap(withId id: Int) {
        updateChildViewControllerWithChosenId(id)
    }
}

extension ReservationViewController: MapUpdater {
    func update(_ date: IntervalDate) {
        //let areBooked = allReservations?.intervals[date.getDateString()]?[date.getFullString()] ?? []
        //mapView?.performUpdate(inactive: areBooked)
    }
}
