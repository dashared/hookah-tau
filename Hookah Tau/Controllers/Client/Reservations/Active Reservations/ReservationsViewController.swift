//
//  RegistrationsViewController.swift
//  Hookah Tau
//
//  Created by cstore on 13/10/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ReservationsViewController: BaseViewController {
    
    // MARK: - Properties
    
    var activeReservations: [Reservation] = [] {
        didSet {
            guard let empty = noReservationsView else { return }
            if activeReservations.isEmpty {
                contentView.bringSubviewToFront(empty)
                empty.alpha = 1
            } else {
                contentView.sendSubviewToBack(empty)
                tableView?.alpha = 1
            }
            
            activityIndicator.stopAnimating()
            tableView?.reloadData()
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
    
    var tableView: UITableView? = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
        reservationsService = ReservationsService(apiClient: APIClient.shared)
        navigationController?.navigationBar.prefersLargeTitles = true
        setUpContentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performUpdate()
    }
    
    // MARK: - Setup
    
    func setUpContentView() {
        self.view.addSubviewThatFills(contentView)
        
        contentView.addSubviewThatFills(activityIndicator)
        activityIndicator.startAnimating()
        
        // empty
        noReservationsView = NoReservationsView.loadFromNib()
        contentView.addSubviewThatFills(noReservationsView)
        noReservationsView?.makeReservationButton?.addTarget(self, action: #selector(tapToMakeReservation), for: .touchUpInside)
        
        noReservationsView?.alpha = 0

        // table
        contentView.addSubviewThatFills(tableView)

        setUpTableView()
        setupRefreshControl()
    }
    
    func setUpTableView() {
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.alpha = 0
        
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
            self?.refrControl?.endRefreshing()
        })
    }
    
    func deleteReservation(uuid: String, completion: @escaping (([Reservation]?) -> Void)) {
        reservationsService?.deleteReservation(isAdmin: false, uuid: uuid) { result in
            if result {
                let newReservations = self.activeReservations.filter { $0.uuid != uuid }
                completion(newReservations)
                return
            }
            
            completion(nil)
        }
    }
    
    // MARK: - Refresh control
    
    var refrControl: UIRefreshControl?
    
    func setupRefreshControl() {
        refrControl = UIRefreshControl()
        tableView?.refreshControl = refrControl
        refrControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc func refreshData( _ ff: UIRefreshControl) {
        performUpdate()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reservation = activeReservations[indexPath.row]
        coordinator?.viewReservation(reservation)
    }
    
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
