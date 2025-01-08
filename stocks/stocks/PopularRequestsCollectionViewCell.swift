//
//  PopularRequestsCollectionViewCell.swift
//  stocks
//
//  Created by Nursultan Turekulov on 06.01.2025.
//

import UIKit

class PopularRequestsCollectionViewCell: UICollectionViewCell {
    static let identifier = "PopularRequestsCollectionViewCell"
    var companyName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x1A1A1A)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        addSubViews()
        setUpConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubview(companyName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            companyName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            companyName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            companyName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func setupCell() {
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .green
    }
}
