//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 1/4/2025.
//

import UIKit

class UserDetailViewController: UITableViewController {

    private let viewModel: UserDetailViewModel

    init(user: User) {
        self.viewModel = UserDetailViewModel(user: user)
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("title_view_detailuser", comment: "")
        self.tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserDetailCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 } // Profil cell
        return viewModel.sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
                return UITableViewCell()
            }
            cell.configureDetail(with: viewModel.user)
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = viewModel.sections[indexPath.section].rows[indexPath.row]
        return cell
    }
}
