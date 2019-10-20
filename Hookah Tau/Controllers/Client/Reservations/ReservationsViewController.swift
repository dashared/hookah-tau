//
//  RegistrationsViewController.swift
//  Hookah Tau
//
//  Created by cstore on 13/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

let reservationCell = "ReservationCell"

class ReservationsViewController: UIViewController {
    
    // MARK: - Properties
    
    var activeReservations = [1]
    
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
        
        setUpContentView()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.register(ReservationCell.self, forCellReuseIdentifier: reservationCell)

        view.backgroundColor = .white
        navigationItem.title = "Брони"
        
        navigationController?.navigationBar.prefersLargeTitles = true
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
        }
    }
    
    // MARK: - handlers
    
    @objc func tapToMakeReservation() {
        coordinator?.makeReservation()
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
