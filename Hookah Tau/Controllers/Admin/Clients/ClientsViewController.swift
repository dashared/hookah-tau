//
//  ClientsViewController.swift
//  Hookah Tau
//
//  Created by cstore on 09/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ClientsViewController: UITableViewController {
    
    // MARK: - Properties
    
    var dataSource: [Client] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var clientsService: ClientsService?
    
    weak var coordinator: ClientsCoordinator?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Клиенты"
        clientsService = ClientsService(apiClient: APIClient.shared)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadClients()
    }

    /// Загружаем клиентов кальянки
    func loadClients() {
        clientsService?.loadClientsList(completion: { [ weak self ] (res) in
            switch res {
            case .failure(let err):
                print(err)
            case .success(let arr):
                self?.dataSource = arr
            }
        })
    }
    
    
    // MARK: - Tableview
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: clientTableViewCellId, for: indexPath) as! ClientTableViewCell
        
        let userModel = dataSource[indexPath.row]
        cell.bind(withModel: userModel)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = dataSource[indexPath.row]
        coordinator?.openUserProfile(user)
    }
}
