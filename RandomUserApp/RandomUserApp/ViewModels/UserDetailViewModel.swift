//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 4/4/2025.
//


import Foundation

class UserDetailViewModel {
    
   let user: User
    
    var sections: [UserDetailSection] = []
    
    init(user: User) {
        self.user = user
        self.sections = buildSections()
    }
    
    private func buildSections() -> [UserDetailSection] {
        return [
            UserDetailSection(title: NSLocalizedString("label_profil", comment: ""), rows: []),
            UserDetailSection(title: NSLocalizedString("label_contact", comment: ""), rows: [
                "Email: \(user.email)",
                NSLocalizedString("label_phone", comment: "") + " \(user.phone)",
                NSLocalizedString("label_celullar", comment: "") + " \(user.cell)"
            ]),
            UserDetailSection(title: NSLocalizedString("label_adress", comment: ""), rows: [
                NSLocalizedString("label_adress", comment: "") + " \(user.formatedAdress)",
                NSLocalizedString("label_dateofbirthday", comment: "") + " \(user.dob.date)"
            ]),
            UserDetailSection(title: NSLocalizedString("label_connexion", comment: ""), rows: [
                "Uuid: \(user.login.uuid)",
                NSLocalizedString("label_username", comment: "") + " \(user.login.username)",
                NSLocalizedString("label_password", comment: "") + " \(user.login.password)"
            ]),
            UserDetailSection(title: NSLocalizedString("label_info", comment: ""), rows: [
                "ID: \(user.id.value ?? "Non disponible")",
                NSLocalizedString("label_nat", comment: "") + " \(user.nat)",
                NSLocalizedString("label_age", comment: "") + " \(user.formattedAge)",
                NSLocalizedString("label_gender", comment: "") + " \(user.gender)"
            ])
        ]
    }
}
