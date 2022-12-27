//
//  TransactionCell.swift
//  TrackingExpenses
//
//  Created by Nodir on 27/12/22.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    //transaction time
    lazy var transactionTime: UILabel = {
        var lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18)
        lbl.text = "20:23"
        lbl.textAlignment = .natural
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lbl
    }()
    
    lazy var amount: UILabel = {
        var lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20)
        lbl.text = "20 000"
        lbl.textAlignment = .natural
        return lbl
    }()
    
    lazy var category: UILabel = {
        var lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.text = "Taxi"
        lbl.textColor = #colorLiteral(red: 0.5503022075, green: 0.5470342636, blue: 0.552816391, alpha: 1)
        lbl.textAlignment = .natural
        
        return lbl
    }()
    
    lazy var leftStack: UIStackView = {
        var stk = UIStackView()
        stk.alignment = .fill
        stk.distribution = .fillProportionally
        stk.addArrangedSubview(amount)
        stk.addArrangedSubview(category)
        stk.axis = .vertical
        stk.spacing = 5
        stk.translatesAutoresizingMaskIntoConstraints = false
        return stk
    }()
    
    lazy var mainStack: UIStackView = {
        var stk = UIStackView()
        stk.alignment = .fill
        stk.distribution = .fill
        stk.addArrangedSubview(leftStack)
        stk.addArrangedSubview(transactionTime)
        stk.axis = .horizontal
        stk.spacing = 5
        stk.translatesAutoresizingMaskIntoConstraints = false
        return stk
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(mainStack)
        
        
        NSLayoutConstraint.activate([
            transactionTime.widthAnchor.constraint(equalToConstant: 60),
            
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            
        ])
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
