//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String)
    
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "24B26E32-44BD-4702-B56F-8C4D0CC17763"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                    
                }
                
                if let safeData = data {
                    
                    if let coinRate = self.parseJSON(safeData) {
                        
                        let priceString = String(format: "%.3f", coinRate)
                        
                        self.delegate?.didUpdatePrice(price: priceString)
                    }
                }
            })
            
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let rate = decodedData.rate
            
            return rate
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
