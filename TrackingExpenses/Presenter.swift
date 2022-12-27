//
//  Presenter.swift
//  TrackingExpenses
//
//  Created by Nodir on 27/12/22.
//

import Foundation

protocol ViewPresenter {
    init(with view: ViewUpdate)
    func viewDidLoad()
    func updateBalanceNlist(amount: Float, category: String?)
}

protocol ViewUpdate {
    func balanceUpdate(balance: String, model: [Transactions])
    func onRetrieveData(_ model: AnyObject?)
}

protocol MakeExpense {
    func expenseData(amount: Float, category: String?)
}
