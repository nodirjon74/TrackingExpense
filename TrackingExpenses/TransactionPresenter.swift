//
//  TransactionPresenter.swift
//  TrackingExpenses
//
//  Created by Nodir on 28/12/22.
//

import CoreData

class TransactionPresenter: MakeExpense {
    
    private var transactions = [Transactions]()
    private let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
    
    func expenseData(amount: Float, category: String?) {
        
        let balanceFetch: NSFetchRequest<Balance> = Balance.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(balanceFetch)
            if let res = results.first {
                res.amount -= amount
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
    }
    
}
