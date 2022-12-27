//
//  PresentView.swift
//  TrackingExpenses
//
//  Created by Nodir on 27/12/22.
//

import CoreData
import Foundation

class PresentView: ViewPresenter {
    
    var view: ViewUpdate?
    
    private var balance: Float = 0.0
    private var transactions = [Transactions]()
    private let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    
    required init(with view: ViewUpdate) {
        self.view = view
    }
    
    func viewDidLoad() {
        updateCoinPrice()
    }
    
    func viewWillAppear() {
        getBalance()
    }
    
    func updateBalanceNlist(amount: Float, category: String?) {
        
        self.balance += amount
        
        let balanceFetch: NSFetchRequest<Balance> = Balance.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(balanceFetch)
            if let res = results.first {
                res.amount = balance
            }
        } catch {
            print("Failed:", error)
        }
        
        let newNote = Transactions(context: managedContext)
        newNote.setValue(Date(), forKey: #keyPath(Transactions.date))
        newNote.setValue(category, forKey: #keyPath(Transactions.group))
        newNote.setValue(amount, forKey: #keyPath(Transactions.amount))
        self.transactions.insert(newNote, at: 0)
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        
        view?.balanceUpdate(balance: "\(self.balance)", model: transactions)
    }
    
    private func getBalance() {
        let balanceFetch: NSFetchRequest<Balance> = Balance.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(balanceFetch)
            if let res = results.first {
                self.balance = res.amount
            } else {
                let newBalance = Balance(context: managedContext)
                newBalance.setValue(self.balance, forKey: #keyPath(Balance.amount))
            }
        } catch {
            print("Failed:", error)
        }
        
        let transactionFetch: NSFetchRequest<Transactions> = Transactions.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(Transactions.date), ascending: false)
        transactionFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(transactionFetch)
            self.transactions = results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        view?.balanceUpdate(balance: "\(self.balance)", model: self.transactions)

    }
    
    func updateCoinPrice() {
        self.reqBitPrice()
    }
    
    @objc func reqBitPrice() {
        Network().request { (result) in
            switch result {
            case .success(let price):
                result
            
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
