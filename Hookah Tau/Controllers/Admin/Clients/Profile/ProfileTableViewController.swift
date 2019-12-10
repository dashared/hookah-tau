//
//  ProfileTableViewController.swift
//  Hookah Tau
//
//  Created by cstore on 10/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    // MARK: - IBAOutlets

    @IBOutlet weak var phoneButton: Button! {
        didSet {
            guard let u = user else { return }
            
            let style = BlackButtonStyle()
            style.apply(to: phoneButton, withTitle: u.phoneNumber.formattedNumber())
            phoneButton.addTarget(self, action: #selector(callUser), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var copyButton: Button! {
        didSet {
            let style = BlackButtonStyle()
            style.apply(to: copyButton, withTitle: "скопировать")
        }
    }
    
    // MARK: - properties
    
    var clientsService: ClientsService?
    
    var user: FullUser? {
        didSet {
            guard let u = user else { return }
            navigationItem.title = u.name
        }
    }
    
    weak var coodinator: ClientProfileCoordinator?
    
    var dataSource: [Reservation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.register(ReservationCell.self, forCellReuseIdentifier: reservationCell)
        
        clientsService = ClientsService(apiClient: APIClient.shared)
        loadReservations()
    }
    
    func loadReservations() {
        guard let uuid = user?.uuid else { return }
        clientsService?.loadReservationsForUser(withUUID: uuid,
                                                completion: { [weak self] (res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let data):
                self?.dataSource = data
            }
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reservationCell, for: indexPath) as! ReservationCell
        
        cell.bind(withModel: dataSource[indexPath.row])
        
        return cell
    }
    
    @objc func callUser() {
        guard
            let u = user,
            let urlPhone = URL(string: "tel://79\(u.phoneNumber)")
        else { return }
        
        UIApplication.shared.open(urlPhone)
    }

}
