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
    
    weak var coordinator: AdminReservationsCoordinator?
    
    var refrControl: UIRefreshControl?
    
    var activityIndicator: UIActivityIndicatorView?
    
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
            activityIndicator?.stopAnimating()
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reservationsService = ReservationsService(apiClient: APIClient.shared)
        setupRefreshControl()
        setUpContentView()
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performUpdate()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK:- Setup
    
    func setupNavBar() {
        self.navigationItem.title = "Брони"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(book))
    }
    
    func setUpContentView() {
        self.view.addSubviewThatFills(contentView)
        
        activityIndicator = UIActivityIndicatorView()
        contentView.addSubviewThatFills(activityIndicator)
        activityIndicator?.startAnimating()
        
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
            self?.refrControl?.endRefreshing()
        })
    }
    
    // MARK:- Button handler
    
    @objc func book() {
        
    }
    
    func deleteReservation(uuid: String, completion: @escaping (([ReservationWithUser]?) -> Void)) {
        reservationsService?.deleteReservation(isAdmin: true, uuid: uuid) { result in
            if result {
                let newReservations = self.activeReservations.filter { $0.uuid != uuid }
                completion(newReservations)
                return
            }
            
            completion(nil)
        }
    }
    
    // MARK: - Refresh control
    
    @objc func refreshData( _ ff: UIRefreshControl) {
        performUpdate()
    }
    
    func setupRefreshControl() {
        refrControl = UIRefreshControl()
        tableView?.refreshControl = refrControl
        refrControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reservation = activeReservations[indexPath.row]
        coordinator?.seeExistingReservation(data: reservation)
    }
    
    // Dimesions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    // Update
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let uuid = activeReservations[indexPath.row].uuid
        let cancelButton = UITableViewRowAction(style: .normal, title: "отменить бронь") { _,_  in
            
            self.deleteReservation(uuid: uuid) { optionalNewVal in
                if let newval = optionalNewVal {
                    self.tableView?.beginUpdates()
                    self.tableView?.deleteRows(at: [indexPath], with: .automatic)
                    self.activeReservations = newval
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
