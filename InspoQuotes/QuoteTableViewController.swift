//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    let productID = "com.copyFromAppleAppStore" //connects to the right product registered on Apple App Store
    
    //var bc later array changes to add premiumQuotes
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quotesToShow.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0 //take as many lines as needed
        } else {
            cell.textLabel?.text = "Get More Quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            cell.accessoryType = .disclosureIndicator //indicates can be pressed for further info
        }
        return cell
    }
    
    //MARK: - Table view delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - In-App Puchases Methods
    
    //create request
    func buyPremiumQuotes() {
        //check to make sure user can buy (ex. no parental control)
        if SKPaymentQueue.canMakePayments() { //true -> can make payment
            
            //make request
            let paymentRequest = SKMutablePayment()
            
            //specify request
            paymentRequest.productIdentifier = productID
            
            //add payment request to queue
            SKPaymentQueue.default().add(paymentRequest)
            
        } else { //false -> can't make payment
            print("User can't make payments")
        }
    }
    
    //delegate to listen when payment successful
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        //check for succesful transactions (can have multiple in array)
        
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //user payment successful
                print("Transaction successful")
                showPremiumQuotes()
                
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                //Payment failed
                print("Transaction failed")
                
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error: \(errorDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func showPremiumQuotes() {
        
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
    }
    
    
}
