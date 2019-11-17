//
//  RegistrationsViewController.swift
//  Hookah Tau
//
//  Created by cstore on 13/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

let reservationCell = "ReservationCell"

class ReservationsViewController: BaseViewController {
    
    // MARK: - Properties
    
    var activeReservations: [Reservation] = [] {
        didSet {
            setUpContentView()
        }
    }
    
    var reservationsService: ReservationsService?
    
    weak var coordinator: ReservationsCoordinator?
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var noReservationsView: NoReservationsView?
    
    var tableView: UITableView?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
        reservationsService = ReservationsService(apiClient: APIClient.shared)
        
        performUpdate()
    }
    
    // MARK: - Setup
    
    func setUpContentView() {
        self.view.addSubviewThatFills(contentView)
        
        if activeReservations.isEmpty {
            noReservationsView = NoReservationsView.loadFromNib()
            contentView.addSubviewThatFills(noReservationsView)
            noReservationsView?.makeReservationButton?.addTarget(self, action: #selector(tapToMakeReservation), for: .touchUpInside)
        } else {
            tableView = UITableView()
            contentView.addSubviewThatFills(tableView)
            tableView?.reloadData()
        }
    
        setUpTableView()
    }
    
    func setUpTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.register(ReservationCell.self, forCellReuseIdentifier: reservationCell)
    }
    
    func setUpNavigationBar() {
        view.backgroundColor = .white
        navigationItem.title = "Брони"
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapToMakeReservation))
    }
    
    // MARK: - handlers
    
    @objc func tapToMakeReservation() {
        coordinator?.makeReservation()
    }
    
    // MARK: - Update
    
    func performUpdate() {
        reservationsService?.loadUsersReservations(completion: { [weak self] (result) in
            switch result {
            case .success(let reservations):
                self?.activeReservations = reservations
            case .failure(let err):
                self?.displayAlert(forError: err)
            }
        })
    }
    
}

extension ReservationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeReservations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reservationCell, for: indexPath) as! ReservationCell
        cell.bind(withModel: activeReservations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
}
