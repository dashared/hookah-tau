//
//  ProfileTableViewController.swift
//  Hookah Tau
//
//  Created by cstore on 10/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {
    
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
            style.apply(to: copyButton, withTitle: "СКОПИРОВАТЬ")
        }
    }
    
    // MARK: - properties
    
    var clientsService: ClientsService?
    
    var reservationsService: ReservationsService?
    
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
        reservationsService = ReservationsService(apiClient: APIClient.shared)
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
    
    @objc func callUser() {
        guard
            let u = user,
            let urlPhone = URL(string: "tel://79\(u.phoneNumber)")
        else { return }
        
        UIApplication.shared.open(urlPhone)
    }
    
    func deleteReservation(uuid: String, completion: @escaping (([Reservation]?) -> Void)) {
        reservationsService?.deleteReservation(isAdmin: true, uuid: uuid) { result in
            if result {
                let newReservations = self.dataSource.filter { $0.uuid != uuid }
                completion(newReservations)
                return
            }
            
            completion(nil)
        }
    }

}

// MARK: - Table view data source

extension ProfileTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reservationCell, for: indexPath) as! ReservationCell
        
        cell.bind(withModel: dataSource[indexPath.row])
        
        return cell
    }
    
    // Update
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let uuid = dataSource[indexPath.row].uuid
        let cancelButton = UITableViewRowAction(style: .normal, title: "❌") { _,_  in
            
            self.deleteReservation(uuid: uuid) { optionalNewVal in
                if let newval = optionalNewVal {
                    self.tableView?.beginUpdates()
                    self.tableView?.deleteRows(at: [indexPath], with: .automatic)
                    self.dataSource = newval
                    self.tableView?.endUpdates()
                } else {
                    self.displayAlert(with: "Не удалось удалить вашу бронь! Попробуйте еще раз!")
                }
            }
        }
        
        cancelButton.backgroundColor = .black
        
        return [cancelButton]
    }
}
