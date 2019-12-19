//
//  AdminReservationsController.swift
//  Hookah Tau
//
//  Created by cstore on 19/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class AdminReservationsController: BaseViewController {
    
    // MARK:- Properties
    
    /// Establishment id
    var id: Int?
    
    var tableView: UITableView? = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var noReservationsView: AdminNoReservationsView?
    
    var reservationsService: ReservationsService?
    
    var activeReservations: [ReservationWithUser] = [] {
        didSet {
            guard let empty = noReservationsView else { return }
            if activeReservations.isEmpty {
                contentView.bringSubviewToFront(empty)
                empty.alpha = 1
            } else {
                contentView.sendSubviewToBack(empty)
                tableView?.alpha = 1
            }
            
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reservationsService = ReservationsService(apiClient: APIClient.shared)
        setUpContentView()
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performUpdate()
    }
    
    // MARK:- Setup
    
    func setupNavBar() {
        self.navigationItem.title = "Брони"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(book))
    }
    
    func setUpContentView() {
        self.view.addSubviewThatFills(contentView)
        
        // empty
        noReservationsView = AdminNoReservationsView.loadFromNib()
        contentView.addSubviewThatFills(noReservationsView)
        noReservationsView?.bookButton?.addTarget(self, action: #selector(book), for: .touchUpInside)
        
        noReservationsView?.alpha = 0

        // table
        contentView.addSubviewThatFills(tableView)

        setUpTableView()
    }
    
    func setUpTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.alpha = 0
        
        tableView?.register(AdminReservationCell.self, forCellReuseIdentifier: adminReservationCellId)
    }
    
    func performUpdate() {
        
        guard let id = id else { return }
        
        reservationsService?.getAdminReservations(establishmentId: id, completion: { [weak self] (result) in
            switch result {
            case .success(let reservations):
                self?.activeReservations = reservations
            case .failure(let err):
                self?.displayAlert(forError: err)
            }
        })
    }
    
    // MARK:- Button handler
    
    @objc func book() {
        
    }

}


// MARK: - Table view data source

extension AdminReservationsController: UITableViewDelegate, UITableViewDataSource {

       func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return activeReservations.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: adminReservationCellId, for: indexPath) as! AdminReservationCell
           
           cell.bind(withModel: activeReservations[indexPath.row])
           return cell
       }
}
