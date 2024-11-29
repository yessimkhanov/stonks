//
//  TableViewCell.swift
//  stoksApp
//
//  Created by Nursultan Turekulov on 19.11.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    weak var delegate : VCDelegate?
    var indexPath: Int?
    var isFavourite : Bool?
    private let logo: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.clipsToBounds = true
        return logo
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let abbreviature: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let price: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let starButton : UIButton = {
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
            logo.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 52),
            logo.heightAnchor.constraint(equalToConstant: 52),
            
            abbreviature.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 10),
            //            abbreviature.widthAnchor.constraint(equalToConstant: 80),
            abbreviature.heightAnchor.constraint(equalToConstant: 24),
            abbreviature.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            name.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: 10),
            //            name.widthAnchor.constraint(equalToConstant: 75),
            name.heightAnchor.constraint(equalToConstant: 16),
            name.topAnchor.constraint(equalTo: abbreviature.bottomAnchor, constant: 2),
            
            price.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10), // Add padding from the right
            price.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), // Center vertically in the cell
            //            price.widthAnchor.constraint(equalToConstant: 70),
            price.heightAnchor.constraint(equalToConstant: 24),
            
            starButton.leadingAnchor.constraint(equalTo: abbreviature.trailingAnchor, constant: 8),
            starButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            starButton.heightAnchor.constraint(equalToConstant: 18),
            starButton.widthAnchor.constraint(equalToConstant: 18),
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
    func configure(logo: UIImage, name: String, abbrv: String, price: Double, background : UIColor, isFavourite: Bool, indexPath: Int) {
        self.logo.image = logo
        self.name.text = name
        self.abbreviature.text = abbrv
        self.price.text = String(format: "%.2f", price)
        self.price.text = "$\(self.price.text!)"
        self.contentView.backgroundColor = background
        self.isFavourite = isFavourite
        if isFavourite {
            self.starButton.tintColor = .systemYellow
        } else {
            self.starButton.tintColor = .systemGray
        }
        self.indexPath = indexPath
    }
    @objc func starButtonPressed() {
        if isFavourite == false {
            starButton.tintColor = .systemYellow
            self.delegate?.markFavouriteCompany(at: indexPath!)
        } else {
            starButton.tintColor = .systemGray
            self.delegate?.unMarkFavouriteCompany(at: indexPath!)
        }
    }
}

protocol VCDelegate: AnyObject {
    func markFavouriteCompany(at indexPath: Int)
    func unMarkFavouriteCompany(at indexPath: Int)
    
}
