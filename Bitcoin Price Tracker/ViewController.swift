//
//  ViewController.swift
//  Bitcoin Price Tracker
//
//  Created by Boleslav Glavatki on 30.05.23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        getPrice()
        getDefaultPrices()
    }

    func getDefaultPrices(){
        let usdPrice = UserDefaults.standard.double(forKey: "USD")
        if usdPrice != 0.0 {
            print(usdPrice)
            self.usdLabel.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "USD")
        }
        let eurPrice = UserDefaults.standard.double(forKey: "EUR")
        if eurPrice != 0.0 {
            print("euro: \(eurPrice)")
            self.eurLabel.text = self.doubleToMoneyString(price: eurPrice, currencyCode: "EUR")
        }
        let jpyPrice = UserDefaults.standard.double(forKey: "JPY")
        if jpyPrice != 0.0 {
            print(jpyPrice)
            self.jpyLabel.text = self.doubleToMoneyString(price: jpyPrice, currencyCode: "JPY")
        }
    }
    
    func getPrice(){
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,JPY,EUR"){
            URLSession.shared.dataTask(with: url) { (data, URLResponse, error) in
                if let data = data{
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Double]{
                        print(json)
                        DispatchQueue.main.async {
                            
                            
                            
                            if let usdPrice = json["USD"]{
                                self.usdLabel.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "USD")
                                UserDefaults.standard.set(usdPrice, forKey: "USD")
                                UserDefaults.standard.synchronize()
                            }
                            if let eurPrice = json["EUR"]{
                                self.eurLabel.text = self.doubleToMoneyString(price: eurPrice, currencyCode: "EUR")
                                UserDefaults.standard.set(eurPrice, forKey: "EUR")
                                UserDefaults.standard.synchronize()
                            }
                            if let jpyPrice = json["JPY"]{
                                self.jpyLabel.text = self.doubleToMoneyString(price: jpyPrice, currencyCode: "JPY")
                                UserDefaults.standard.set(jpyPrice, forKey: "JPY")
                                UserDefaults.standard.synchronize()
                            }
                        }
                    }
                }else{
                    print("Something wnet wrong!")
                }
            }.resume()
        }
    }

    func doubleToMoneyString(price: Double, currencyCode: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
       let priceString = formatter.string(from:  NSNumber(value: price))
        return priceString
    }
    
    @IBAction func refreshPrice(_ sender: Any) {
    }
    
    
    
}

