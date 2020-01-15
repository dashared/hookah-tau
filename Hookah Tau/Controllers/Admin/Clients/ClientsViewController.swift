//
//  ClientsViewController.swift
//  Hookah Tau
//
//  Created by cstore on 09/12/2019.
//  Copyright © 2019 Daria Rednikina. All rights reserved.
//

import UIKit

class ClientsViewController: BaseTableViewController {
    
    // MARK: - Properties
    
    var dataSource: [Client] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var filteredDataSource: [Client] = []
    
    var clientsService: ClientsService?
    
    weak var coordinator: ClientsCoordinator?
    
    var searchControl: UISearchController?
    
    var isFiltering: Bool {
        return searchControl?.isActive ?? false && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchControl?.searchBar.text?.isEmpty ?? true
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupSearchController()
        clientsService = ClientsService(apiClient: APIClient.shared)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadClients()
    }
    
    // MARK: - Setup
    
    func setupNavigationBar() {
        
        navigationItem.title = "Клиенты"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareCSVFile))
    }
    
    func setupSearchController() {
        searchControl = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchControl
        navigationItem.hidesSearchBarWhenScrolling = false
        searchControl?.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchControl?.searchResultsUpdater = self
    }
    
    // MARK: - Api calls

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
    
    // MARK: - Button handlers
    
    /// https://developer.apple.com/design/human-interface-guidelines/ios/views/activity-views/
    @objc func shareCSVFile() {
        //Your CSV text
        let str = HFunc.main.exportClientsToCSV(dataSource)
        let filename = getDocumentsDirectory().appendingPathComponent("clients.csv")

        do {
            try str.write(toFile: filename, atomically: true, encoding: String.Encoding.utf8)

            let fileData = NSURL(fileURLWithPath: filename)

            let objectsToShare = [fileData]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            self.present(activityVC, animated: true, completion: nil)

        } catch {
            self.displayAlert(with: "По какой-то причине не могу сохранить файл!")
        }
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory as NSString
    }
    
    // MARK: - Change blocklist status
    
    func updateUserBlockStatus(wasBlocked: Bool, phone: String, indexPath: IndexPath) {
        let crudMethod = wasBlocked ? CrudMethod.delete : CrudMethod.put
        clientsService?.changeBlockList(whatToDo: crudMethod, phone: phone, completion: { (res) in
            if res {
                self.tableView?.beginUpdates()
                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
                if self.isFiltering {
                    self.filteredDataSource[indexPath.row].isBlocked = !wasBlocked
                    let changed = self.filteredDataSource[indexPath.row]
                    let filtered = self.dataSource.map { (one: Client) -> Client in
                        if one.uuid == changed.uuid {
                            return changed
                        } else { return one } }
                    self.dataSource = filtered
                } else {
                    self.dataSource[indexPath.row].isBlocked = !wasBlocked
                }
                self.tableView?.endUpdates()
            } else {
                self.displayAlert(with: "Не удалось \(wasBlocked ? "удалить" : "добавить") пользователя \(wasBlocked ? "из" : "в") чс! Попробуйте еще раз!")
                return
            }
        })
    }
    
    func updateAdminStatus(user: Client, indexPath: IndexPath) {
        
        let wasAdmin = user.isAdmin
        let crudMethod = wasAdmin ? CrudMethod.delete : CrudMethod.put
        let data = user.isAdmin ? user.uuid : user.phoneNumber
        
        clientsService?.changeAdmin(crud: crudMethod, data: data, completion: { (res) in
            if res {
                self.tableView?.beginUpdates()
                self.tableView?.reloadRows(at: [indexPath], with: .automatic)
                if self.isFiltering {
                    self.filteredDataSource[indexPath.row].isAdmin = !wasAdmin
                    let changed = self.filteredDataSource[indexPath.row]
                    let filtered = self.dataSource.map { (one: Client) -> Client in
                        if one.uuid == changed.uuid {
                            return changed
                        } else { return one } }
                    self.dataSource = filtered
                } else {
                    self.dataSource[indexPath.row].isAdmin = !wasAdmin
                }
                self.tableView?.endUpdates()
            } else {
                self.displayAlert(with: "Не удалось \(wasAdmin ? "распромоутить" : "запромоутить") пользователя! Попробуйте еще раз!")
                return
            }
        })
    }
}

// MARK: - Tableview

extension ClientsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: clientTableViewCellId, for: indexPath) as! ClientTableViewCell
        
        let userModel = isFiltering ? filteredDataSource[indexPath.row] : dataSource[indexPath.row]
        cell.bind(withModel: userModel)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredDataSource.count : dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isFiltering ? filteredDataSource[indexPath.row] : dataSource[indexPath.row]
        coordinator?.openUserProfile(user)
        searchControl?.dismiss(animated: true, completion: nil)
    }
    
    // Update
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let user = isFiltering ? filteredDataSource[indexPath.row] : dataSource[indexPath.row]
        let blockButton = UITableViewRowAction(style: .normal, title: "\(!user.isBlocked ? "в чс" : "убрать из чс")") { _,_  in
            
            self.updateUserBlockStatus(wasBlocked: user.isBlocked, phone: user.phoneNumber, indexPath: indexPath)
        }
        
        blockButton.backgroundColor = .black
        
        return [blockButton]
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let user = isFiltering ? filteredDataSource[indexPath.row] : dataSource[indexPath.row]
        
        let promote = UIContextualAction(style: .normal, title: "\(!user.isAdmin ? "дать админку" : "забрать админку")") { (_, _, _) in
            self.updateAdminStatus(user: user, indexPath: indexPath)
        }
        promote.backgroundColor = .black
        
        return UISwipeActionsConfiguration(actions: [promote])
    }
}

extension ClientsViewController: UISearchResultsUpdating {
    func filterContentForSearchText(_ searchText: String, scope: String = "All")
    {
        filteredDataSource = dataSource.filter { ($0.name?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.phoneNumber.lowercased().contains(searchText.lowercased())) }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
}
