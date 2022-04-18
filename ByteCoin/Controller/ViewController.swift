//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }

    
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectCurrency = coinManager.currencyArray[row]
        
        currencyLabel.text = selectCurrency
        coinManager.getCoinPrice(for: selectCurrency)
    }
}

//MARK: - UIUpdateDelegate

extension ViewController: CoinManagerDelegate {
    
    func didUpdatePrice(price: String) {
        DispatchQueue.main.async {
            print(price)
            self.currency.text = price
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
