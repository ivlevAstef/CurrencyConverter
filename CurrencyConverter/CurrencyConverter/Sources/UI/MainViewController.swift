//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import DITranquillity

class MainViewController: UIViewController, CurrencyWriterDelegate {
  private let server : ServerProtocol
  private var mainView: MainView! { return self.view as! MainView }
  
  required init?(coder aDecoder: NSCoder) {
    server = *!DIMain.container!
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.mainView.myCurrencyWriter.delegate = self
    self.mainView.wantCurrencyWriter.delegate = self
    
    self.loadCurrencies()
  }
  
  private func loadCurrencies() {
    mainView.activityIndicator(show: true)
    server.getCurrencies { (currenciesOpt, error) in
      self.mainView.activityIndicator(show: false)
      
      guard let currencies = currenciesOpt else {
        return
      }
      
      self.mainView.myCurrencyWriter.setCurrencies(currencies)
      self.mainView.wantCurrencyWriter.setCurrencies(currencies)
    }
  }
  
  func currencyWriter(writer: CurrencyWriter, amountChanges amount: String) {
    let getOtherCurrencyWriter = {(currencyWriter: CurrencyWriter) -> CurrencyWriter in
      if self.mainView.myCurrencyWriter === currencyWriter {
        return self.mainView.wantCurrencyWriter
      }
      return self.mainView.myCurrencyWriter
    }
    
    updateCurrencyWriter(getOtherCurrencyWriter(writer), use: writer)
  }
  
  func currencyWriter(writer: CurrencyWriter, currencyChanges currency:Currency) {
    updateCurrencyWriter(mainView.wantCurrencyWriter, use: mainView.myCurrencyWriter)
  }
  
  private func updateCurrencyWriter(writer: CurrencyWriter, use writerForGet: CurrencyWriter) {
    let fromValue = writerForGet.getSelectedCurrency().value
    let toValue = writer.getSelectedCurrency().value
    
    guard let fromAmount = amountFormatter.numberFromString(writerForGet.getCurrentAmount())?.doubleValue else {
      return
    }
    
    let toAmount = fromAmount * toValue / fromValue
    guard let toAmountStr = amountFormatter.stringFromNumber(toAmount) else {
      return
    }
    
    writer.setCurrentAmount(toAmountStr)
  }
  
  private let amountFormatter: NSNumberFormatter = {
    var result = NSNumberFormatter()
    result.numberStyle = NSNumberFormatterStyle.DecimalStyle
    result.locale = NSLocale.currentLocale()
    
    return result
  }()
}

