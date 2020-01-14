//
//  ProfileTableViewController.swift
//  Hookah Tau
//
//  Created by cstore on 10/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseViewController {
    
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
            copyButton.addTarget(self, action: #selector(copyNumber(_:)), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - properties
    
    var tableView: UITableView?
    
    var clientsService: ClientsService?
    
    var reservationsService: ReservationsService?
    
    var user: Client?
    
    weak var coodinator: ClientProfileCoordinator?
    
    var noReserationsYetView: AdminNoReservationsView?
    
    var activityIndicator: UIActivityIndicatorView?
    
    var refreshControl: UIRefreshControl?
    
    var dataSource: [Reservation] = [] {
        didSet {
            guard let empty = noReserationsYetView else { return }
            if dataSource.isEmpty {
                empty.alpha = 1
                tableView?.alpha = 0
            } else {
                empty.alpha = 0
                tableView?.alpha = 1
            }
            
            refreshControl?.endRefreshing()
            activityIndicator?.stopAnimating()
            tableView?.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clientsService = ClientsService(apiClient: APIClient.shared)
        reservationsService = ReservationsService(apiClient: APIClient.shared)
        
        setupNavBar()
        setupTable()
        setupActivityIndicator()
        loadReservations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Setup
    
    func setupNavBar() {
        guard let u = user else { return }
        
        navigationItem.title = "\(u.name ?? "❔")\(u.isAdmin ? "👑" : "")\(u.isBlocked ? "❌" : "")"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(book))
    }
    
    func setupTable() {
        tableView = UITableView()
        
        // refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView?.refreshControl = refreshControl
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        noReserationsYetView = AdminNoReservationsView.loadFromNib()
        noReserationsYetView?.setup(withTitle: "У этого пользователя пока нет ни одной брони :(")
        noReserationsYetView?.bookButton?.addTarget(self, action: #selector(book), for: .touchUpInside)
        contentView.addSubviewThatFills(noReserationsYetView)
        noReserationsYetView?.alpha = 0
        
        tableView?.register(ReservationCell.self, forCellReuseIdentifier: reservationCell)
        
        contentView.addSubviewThatFills(tableView)
        
        tableView?.alpha = 0
    }
    
    func setupActivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView()
        view.addSubviewThatFills(activityIndicator)
        activityIndicator?.startAnimating()
        
    }
    
    // MARK: - Api calls
    
    func loadReservations() {
        guard let uuid = user?.uuid else { return }
        clientsService?.loadReservationsForUser(withUUID: uuid,
                                                completion: { [weak self] (res) in
            switch res {
            case .failure(let err):
                self?.displayAlert(forError: err)
            case .success(let data):
                self?.dataSource = data
            }
        })
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
    
    // MARK: - Button handlers
    
    @objc func callUser() {
        guard
            let u = user,
            let urlPhone = URL(string: "tel://79\(u.phoneNumber)")
        else { return }
        
        UIApplication.shared.open(urlPhone)
    }
    
    @objc func copyNumber(_ sender: UIButton) {
        guard
            let u = user
        else { return }
        //Copy a string to the pasteboard.
        UIPasteboard.general.string = "79\(u.phoneNumber)"
        
        //Alert
        self.displayAlert(with: "Номер скопирован!")
    }
    
    @objc func refresh() {
        loadReservations()
    }
    
    @objc func book() {
        
    }
}

// MARK: - Table view data source

extension ProfileTableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reservationCell, for: indexPath) as! ReservationCell
        
        cell.bind(withModel: dataSource[indexPath.row])
        
        return cell
    }
    
    // tap
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let u = user else { return }
        let r = dataSource[indexPath.row]
        let user = FullUser(uuid: u.uuid, name: u.name, phoneNumber: u.phoneNumber, isAdmin: u.isAdmin)
        let reservation = ReservationWithUser(reservation: r, user: user)
        coodinator?.seeExistingReservation(data: reservation)
    }
    
    // Update
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let uuid = dataSource[indexPath.row].uuid
        let cancelButton = UITableViewRowAction(style: .normal, title: "отменить бронь") { _,_  in
            
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
