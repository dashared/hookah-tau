//
//  AdminReservationsController.swift
//  Hookah Tau
//
//  Created by cstore on 19/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminReservationsController: UITableViewController {
    
    // MARK:- Properties
    
    /// Establishment id
    var id: Int?
    var reservationsService: ReservationsService?
    var activeReservations: [ReservationWithUser] = [] {
        didSet {
            //guard let empty = noReservationsView else { return }
            if activeReservations.isEmpty {
                //contentView.bringSubviewToFront(empty)
                //empty.alpha = 1
            } else {
                //contentView.sendSubviewToBack(empty)
                tableView?.alpha = 1
            }
            
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reservationsService = ReservationsService(apiClient: APIClient.shared)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performUpdate()
    }
    
    func performUpdate() {
        
        guard let id = id else { return }
        
        reservationsService?.getAdminReservations(establishmentId: id, completion: { [weak self] (result) in
            switch result {
            case .success(let reservations):
                self?.activeReservations = reservations
            case .failure(let err):
                //self?.displayAlert(forError: err)
                print(err)
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeReservations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminReservationCell", for: indexPath) as! AdminReservationCell
        
        cell.bind(withModel: activeReservations[indexPath.row])
        return cell
    }

}
