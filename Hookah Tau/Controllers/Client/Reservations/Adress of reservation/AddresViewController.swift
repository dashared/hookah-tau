//
//  AddressViewController.swift
//  Hookah Tau
//
//  Created by cstore on 25/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AddresViewController: BaseViewController {
    
    // MARK: - Properties
    
    weak var coordinator: AddressCoordinator?
    
    var tableView: UITableView?
    
    var dataSource: [Int]? = [1, 2]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        navigationItem.title = "Заведения"
        
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Setup
    
    func setUpTableView() {
        tableView = UITableView()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.register(AddressCell.self, forCellReuseIdentifier: addressCellIdentifier)
        
        view.addSubviewThatFills(tableView)
    }
}

// MARK: - TableView

extension AddresViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: addressCellIdentifier,
                                                 for: indexPath) as! AddressCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 168.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let establishment = dataSource?[indexPath.row]
        guard let id = establishment else { return }
        
        coordinator?.chooseTableAndTime(inEstablishment: id)
    }
    
    
    
}
