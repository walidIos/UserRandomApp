//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 31/3/2025.
//

import UIKit
import DesignSystem

class UserCell: UITableViewCell {
    
    private let cardView = DSCardView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User) {
        cardView.configure(name: user.fullName, birthday: user.formattedAge, email: user.email, phone: user.phone, imageURL: user.picture.large, location: user.formatedAdress)
    }
    
    func configureDetail(with user: User) {
        cardView.configureDetail(name: user.fullName, imageURL: user.picture.large)
    }
}
