//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 1/4/2025.
//

import UIKit

class UserDetailViewController: UITableViewController {

    var user: User

    init(user: User) {
        self.user = user
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
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 3
        case 4:
            return 4
        default:
            return 0
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     

        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
                     return UITableViewCell()
                 }
            cell.configureDetail(with: user)
                return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailCell", for: indexPath)
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.textLabel?.text = "Email:"+" \(user.email)"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = NSLocalizedString("label_phone", comment: "")+" \(user.phone)"
            } else if indexPath.row == 2 {
                cell.textLabel?.text = NSLocalizedString("label_celullar", comment: "")+" \(user.cell)"
            }
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailCell", for: indexPath)
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.textLabel?.text = NSLocalizedString("label_adress", comment: "")+" \(user.formatedAdress)"
            } else if indexPath.row == 1 {
                cell.textLabel?.text =  NSLocalizedString("label_dateofbirthday", comment: "")+" \(user.formattedDate)"
            }
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailCell", for: indexPath)
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.textLabel?.text = "Uuid: \(user.login.uuid)"
            } else if indexPath.row == 1 {
                cell.textLabel?.text =  NSLocalizedString("label_username", comment: "")+" \(user.login.username)"
            }
            else if indexPath.row == 2 {
                cell.textLabel?.text =  NSLocalizedString("label_password", comment: "")+" \(user.login.password)"
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailCell", for: indexPath)
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.textLabel?.text = "ID: \(user.id.value ?? "Non disponible")"
            } else if indexPath.row == 1 {
                cell.textLabel?.text =   NSLocalizedString("label_nat", comment: "")+" \(user.nat)"
            } else if indexPath.row == 2 {
                cell.textLabel?.text = NSLocalizedString("label_age", comment: "")+" \(user.formattedAge)"
            }
            else if indexPath.row == 3 {
                cell.textLabel?.text = NSLocalizedString("label_gender", comment: "")+" \(user.gender)"
            }
            return cell
        default:
            break
        }

        return UITableViewCell()
    }


    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("label_profil", comment: "")
        case 1:
            return NSLocalizedString("label_contact", comment: "")
        case 2:
            return NSLocalizedString("label_adress", comment: "")
        case 3:
            return NSLocalizedString("label_connexion", comment: "")
        case 4:
            return NSLocalizedString("label_info", comment: "")
        default:
            return nil
        }
    }
}
