//
//  TransactionController.swift
//  TrackingExpenses
//
//  Created by Nodir on 27/12/22.
//

import UIKit

class TransactionController: UIViewController {
    
    //MARK: Property
    let categories = ["Groceries", "Taxi", "Electronics", "Restaurant", "Others"]
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var selectedCategory = ""
    lazy var presenter = TransactionPresenter()
    //MARK: UI Components
    
    lazy var expenseAmount: UITextField = {
        var textField = UITextField()
        textField.keyboardType = .numbersAndPunctuation
        textField.placeholder = "Amount"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 22)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var collectionView: UICollectionView = {
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 150, height: 50)
        var clView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        clView.delegate = self
        clView.dataSource = self
        clView.alwaysBounceVertical =  true
        clView.backgroundColor = .clear
        clView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        clView.translatesAutoresizingMaskIntoConstraints = false
        clView.showsVerticalScrollIndicator = false
        return clView
    }()
    
    lazy var addExpense: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        btn.layer.cornerRadius = 10
        btn.setTitle("Add", for: .normal)
        btn.addTarget(self, action: #selector(addPressed(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        // Do any additional setup after loading the view.
        view.backgroundColor = #colorLiteral(red: 0.9538777471, green: 0.9482070804, blue: 0.9582366347, alpha: 1)
    }
    
    
    private func setupConstraints() {
        
        self.view.addSubview(expenseAmount)
        self.view.addSubview(collectionView)
        self.view.addSubview(addExpense)
        
        NSLayoutConstraint.activate([
            expenseAmount.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            expenseAmount.heightAnchor.constraint(equalToConstant: 35),
            expenseAmount.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            expenseAmount.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40),
            collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            collectionView.topAnchor.constraint(equalTo: self.expenseAmount.bottomAnchor, constant: 20),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            
            addExpense.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addExpense.heightAnchor.constraint(equalToConstant: 50),
            addExpense.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            addExpense.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @objc func addPressed(_ sender: UIButton) {
        if selectedCategory != "" && expenseAmount.text != "" {
            presenter.expenseData(amount: Float(expenseAmount.text!)!, category: selectedCategory)
            navigationController?.popViewController(animated: true)
        }
    }
}

extension TransactionController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.backgroundColor = .white
        cell.category.text = categories[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
    }
    
}
