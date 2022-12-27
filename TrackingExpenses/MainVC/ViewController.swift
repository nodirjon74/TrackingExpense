//
//  ViewController.swift
//  TrackingExpenses
//
//  Created by Nodir on 27/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    //MARK: - Properties
    
    lazy var presenter = PresentView(with: self)
    var transactionListData = [Transactions]()
    let date = Date()
    let dateFormatter = DateFormatter()
    
    //MARK: - UI Components
    lazy var balanceLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = .systemFont(ofSize: 35)
        lbl.text = "0"
        lbl.textAlignment = .natural
        return lbl
    }()
    
    lazy var addBalance: UIButton = {
        var btn = UIButton()
        btn.setBackgroundImage(UIImage.init(systemName: "plus.circle.fill"), for: .normal)
        btn.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        btn.addTarget(self, action: #selector(addBalancePressed(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var addTransaction: UIButton = {
        var btn = UIButton()
        btn.setTitle("Add Transaction", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(addTransactionPressed(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var balanceStack: UIStackView = {
        var stk = UIStackView()
        stk.alignment = .fill
        stk.distribution = .fill
        stk.addArrangedSubview(balanceLabel)
        stk.addArrangedSubview(addBalance)
        stk.axis = .horizontal
        stk.spacing = 10
        stk.translatesAutoresizingMaskIntoConstraints = false
        return stk
    }()
    
    lazy var transactionList: UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        // Do any additional setup after loading the view.
        setupConstraints()
        setupNavItem()
        view.backgroundColor = .white
        Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(presenter.reqBitPrice), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }


    private func setupNavItem() {
        let leftBarButton = UIBarButtonItem()
        leftBarButton.accessibilityRespondsToUserInteraction = false
        leftBarButton.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        self.navigationItem.rightBarButtonItem = leftBarButton
    }
    
    private func setupConstraints() {
        
        self.view.addSubview(balanceStack)
        self.view.addSubview(addTransaction)
        self.view.addSubview(transactionList)
        
        NSLayoutConstraint.activate([
            
            addBalance.widthAnchor.constraint(equalToConstant: 30),
            addBalance.heightAnchor.constraint(equalToConstant: 30),
            
            balanceStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            balanceStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            balanceStack.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 0.8),
            
            addTransaction.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7),
            addTransaction.heightAnchor.constraint(equalToConstant: 45),
            addTransaction.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addTransaction.topAnchor.constraint(equalTo: self.balanceStack.bottomAnchor, constant: 20),
            
            transactionList.topAnchor.constraint(equalTo: self.addTransaction.bottomAnchor, constant: 20),
            transactionList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            transactionList.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            transactionList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            
        ])
    }
    
    
    @objc func addBalancePressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Fill Balance", message: "Enter amount you want to add", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Amount"
            textField.keyboardType = .numbersAndPunctuation
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { [self] _ in

            // this code runs when the user hits the "save" button

            let input = alertController.textFields![0].text
            
            if input != "" {
                presenter.updateBalanceNlist(amount: Float(input!)!, category: nil)
            }

        }

        alertController.addAction(cancelAction)
        alertController.addAction(addAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func addTransactionPressed(_ sender: UIButton) {
        let vc = TransactionController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: transactionListData[section].date!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(transactionListData.count)
        return transactionListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell
        cell.amount.text = "\(transactionListData[indexPath.row].amount)"
        cell.category.text = transactionListData[indexPath.row].group ?? ""
        
        dateFormatter.dateFormat = "HH:mm"
        cell.transactionTime.text = dateFormatter.string(from: transactionListData[indexPath.row].date!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


extension ViewController: ViewUpdate {
    
    func balanceUpdate(balance: String, model: [Transactions]) {
        balanceLabel.text = balance
        self.transactionListData = model
        transactionList.reloadData()
    }
    
    func onRetrieveData(_ model: AnyObject?) {
        
    }
}
