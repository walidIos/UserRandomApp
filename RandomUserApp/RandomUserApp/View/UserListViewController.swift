//
//  ViewController.swift
//  RandomUserApp
//
//  Created by walid on 28/3/2025.
//

import UIKit
import DesignSystem

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
    var viewModel: UserViewModel!
    private var debounceTimer: Timer?
    private lazy var reloadButton: DSButton = DSButton(title: NSLocalizedString("tittle_button_reload", comment: ""), action: {
        self.viewModel.users = []
        self.loadUsers()
    })
    
    private var errorView: DSErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        let repository = UserRepository(networkManager: NetworkManager(networking: URLSession.shared)) //
        let userDefaultsManager = UserDefaultsManager()
        viewModel = UserViewModel(repository: repository, userDefaultsManager: userDefaultsManager)
        loadUsers()
    }
    
    func loadUsers() {
        LoaderManager.shared.showLoader(on: self.view)
        viewModel.loadUsers() { [weak self] errorMessage in
            DispatchQueue.main.async {
                if let message = errorMessage {
                    self?.showErrorView(message: message, retryAction: {
                        self?.loadUsers()
                    })
                    LoaderManager.shared.hideLoader()
                    self?.tableView.reloadData()
                } else {
                    self?.removeErrorView()
                    LoaderManager.shared.hideLoader()
                    self?.tableView.reloadData()
                }
            }
        }
        
    }
    
    private  var titleView = TitleView(title: NSLocalizedString("title_view_list_contact", comment: ""))
    
    private func setupTableView() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        view.addSubview(titleView)
        view.addSubview(reloadButton)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 40),
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: reloadButton.topAnchor, constant: -20),
            
            reloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            reloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            reloadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func showErrorView(message: String, retryAction: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.errorView?.removeFromSuperview()
            let errorView = DSErrorView(message: message, retryAction: retryAction)
            self.view.addSubview(errorView)
            errorView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                errorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                errorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                errorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                errorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
            ])
            
            self.errorView = errorView
            
        }
    }
    
    private func removeErrorView() {
        DispatchQueue.main.async {
            self.errorView?.removeFromSuperview()
            self.errorView = nil
        }
    }
    private func debounceLoadUsers() {
        debounceTimer?.invalidate() // Annule le précédent timer si nécessaire
        debounceTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(loadUsersDebounced), userInfo: nil, repeats: false)
    }
    @objc private func loadUsersDebounced() {
        loadUsers()// Appelle loadUsers après un délai de 0.3 secondes
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.users[indexPath.row])
        cell.selectionStyle = .none
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser =  viewModel.users[indexPath.row]
        let userDetailVC = UserDetailViewController(user: selectedUser)
        if let navigationController = self.navigationController {
            navigationController.pushViewController(userDetailVC, animated: true)
        } else {
            print("NavigationController non disponible")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height - 100 {
            debounceLoadUsers()
            
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeErrorView()
    }
}

