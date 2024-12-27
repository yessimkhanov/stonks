//
//  TableViewCell.swift
//  stoksApp
//
//  Created by Nursultan Turekulov on 19.11.2024.
//

import UIKit

protocol TickerCellDelegate: AnyObject {
    func starButtonPressed(at index: Int, for state: Bool)
}

final class TickerCell: UITableViewCell {
    weak var delegate: TickerCellDelegate?
    private var indexPath: Int?
    private var isFavourite : Bool?
    
    private let logo: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.clipsToBounds = true
        return logo
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let abbreviature: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Montserrat-Bold", size: 23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let starButton: UIButton = {
        let button = UIButton(type: .system)
        let iconImage = UIImage(systemName: "star.fill")
        button.setImage(iconImage, for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setConstraints()
        addTargets()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        logo.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            logo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            logo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            logo.widthAnchor.constraint(equalToConstant: 52),
            logo.heightAnchor.constraint(equalToConstant: 52),
            
            abbreviature.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 12),
            abbreviature.heightAnchor.constraint(equalToConstant: 24),
            abbreviature.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            
            name.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 12),
            name.heightAnchor.constraint(equalToConstant: 16),
            name.topAnchor.constraint(equalTo: abbreviature.bottomAnchor, constant: 0),
            
            price.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
            price.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            price.heightAnchor.constraint(equalToConstant: 24),
            
            starButton.leadingAnchor.constraint(equalTo: abbreviature.trailingAnchor, constant: 6),
            starButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            starButton.heightAnchor.constraint(equalToConstant: 16),
            starButton.widthAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    private func addSubViews() {
        contentView.addSubview(logo)
        contentView.addSubview(name)
        contentView.addSubview(abbreviature)
        contentView.addSubview(price)
        contentView.addSubview(starButton)
    }
    
    private func addTargets() {
        starButton.addTarget(self, action: #selector(starButtonPressed), for: .touchUpInside)
    }
    
    func configure(
        logo: UIImage,
        name: String,
        abbreviature: String,
        price: Double,
        background : UIColor,
        isFavourite: Bool,
        indexPath: Int
    ) {
        self.logo.image = logo
        self.name.text = name
        self.abbreviature.text = abbreviature
        self.price.text = String(format: "%.2f", price)
        self.price.text = "$\(self.price.text!)"
        self.contentView.backgroundColor = background
        self.isFavourite = isFavourite
        self.starButton.tintColor = UIColor(rgb: isFavourite ? 0xFFCA1C : 0xBABABA)
        self.indexPath = indexPath
    }
    
    @objc
    private func starButtonPressed() {
        if let isFavourite, let indexPath {
            self.delegate?.starButtonPressed(at: indexPath, for: isFavourite)
            self.starButton.tintColor = UIColor(rgb: isFavourite ? 0xFFCA1C : 0xBABABA)
        }
    }
}

