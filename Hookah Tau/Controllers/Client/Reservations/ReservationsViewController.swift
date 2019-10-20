//
//  RegistrationsViewController.swift
//  Hookah Tau
//
//  Created by cstore on 13/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ReservationsViewController: UIViewController {
    
    // MARK: - Properties
    
    var activeReservations = [Int]()
    
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

        view.backgroundColor = .white
        navigationItem.title = "Брони"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setUpContentView()
    }
    
    // MARK: - Setup
    
    func setUpContentView() {
        self.view.addSubviewThatFills(contentView)
        
        if activeReservations.isEmpty {
            noReservationsView = NoReservationsView.loadFromNib()
            contentView.addSubviewThatFills(noReservationsView)
            noReservationsView?.makeReservationButton?.addTarget(self, action: #selector(tapToMakeReservation), for: .touchUpInside)
        } else {
            print("TODO")
        }
    }
    
    // MARK: - handlers
    
    @objc func tapToMakeReservation() {
        coordinator?.makeReservation()
    }
    
}

//extension ReservationsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return activeReservations.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell =
//    }
//
//
//}
