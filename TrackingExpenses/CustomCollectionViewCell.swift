//
//  CustomCollectionViewCell.swift
//  TrackingExpenses
//
//  Created by Nodir on 28/12/22.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    lazy var category: UILabel = {
        var lbl = UILabel()
        lbl.font = .systemFont(ofSize: 22)
        lbl.textAlignment = .center
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? #colorLiteral(red: 0.9752754569, green: 0.3682590425, blue: 0.3400309086, alpha: 1) : UIColor.white
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        category.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.addSubview(category)
        self.layer.cornerRadius = 15
        NSLayoutConstraint.activate([
            
            category.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            category.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            category.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            category.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            
        ])
        
    }
    
}
