//
//  SecondStepReservationViewController.swift
//  Hookah Tau
//
//  Created by cstore on 21/11/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class SecondStepReservationViewController: BaseViewController {

    // MARK: - Properties
    
    @IBOutlet weak var childContentView: UIView!
    
    var secondStepView: SecondStepView?
    
    /// координатор
    weak var coordinator: SecondStepReservationCoordinator?
    
    /// service для создания бронирования
    var reservationService: ReservationsService?
    
    /// map view from the previous screen
    var mapView: MapImageScroll? 
    
    var model: SecondStepModel?
    
    /// address of the building to display in nav bar title
    var address: String = "Покровский бр., 11"
    
    let confirmButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ПОДТВЕРДИТЬ")
        return button
    }()
    
    let cancelButton: Button = {
        let button = Button()
        let style = BlackButtonStyle()
        style.apply(to: button, withTitle: "ОТМЕНИТЬ")
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupMap()
        setupChildContainer()
        setupButtons()
    
        reservationService = ReservationsService(apiClient: APIClient.shared)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    
    // MARK: - Setup
    
    func setupNavBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = address
    }

    func setupChildContainer() {
        
        secondStepView = SecondStepView.loadFromNib()
        childContentView.addSubviewThatFills(secondStepView)
        guard let model = model else { return }
        secondStepView?.bind(model: model)
    }
    
    func setupMap() {
        guard let map = mapView else { return }
        view.addSubview(map)
        
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            map.bottomAnchor.constraint(equalTo: childContentView.topAnchor, constant: 0)
        ])
        
        let width = view.frame.width
        
        mapView?.scrollViewParent.setContentOffset(CGPoint(x: 0, y: 100), animated: false)
        mapView?.scrollViewParent.contentInset = UIEdgeInsets(top: 0,
                                                              left: width / 2,
                                                              bottom: -100,
                                                              right: width / 2)
        mapView?.isUserInteractionEnabled = false
        view.sendSubviewToBack(map)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mapView?.scrollToTable(table: model?.table ?? 0)
    }
    
    func setupButtons() {
        addStackViewWithButtons(leftBtn: cancelButton,
                                rightBtn: confirmButton,
                                constant: -childContentView.frame.height - 20)
        cancelButton.addTarget(self, action: #selector(cancelChange), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(book), for: .touchUpInside)
    }
    
    // MARK: - Button handlers
    
    @objc func cancelChange() {
        coordinator?.cancel(mapView)
    }
    
    @objc func book() {
        guard let booking = secondStepView?.data else { return }
        confirmButton.loading = true
        
        print(booking)
        
        reservationService?.createReservation(data: booking, completion: { [weak self] (result) in
            switch result {
            case .failure:
                self?.displayAlert(with: "Не удалось совершить бронирование :(")
                
            case .success(let reservation):
                self?.coordinator?.book(self?.mapView, reservation: reservation)
            }

            self?.confirmButton.loading = false
        })
    }
}
