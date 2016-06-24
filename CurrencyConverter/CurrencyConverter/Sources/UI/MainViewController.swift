//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import DITranquillity
import SIALoggerSwift

class MainViewController: UIViewController, CurrencyWriterDelegate {
  private let server : ServerProtocol
  private var mainView: MainView! { return self.view as! MainView }
  private var currencies: [Currency]? = nil
  
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
        self.showAlert(error ?? "No Internet") {
          //abort()
          self.loadCurrencies()
        }
        return
      }
      
      let sortedCurrencies = currencies.sort { $0.name < $1.name }
      
      self.currencies = sortedCurrencies
      self.mainView.myCurrencyWriter.setCurrencies(sortedCurrencies.map{ $0.name })
      self.mainView.wantCurrencyWriter.setCurrencies(sortedCurrencies.map{ $0.name })
      
      self.updateInterface(self.mainView.myCurrencyWriter, use: self.mainView.wantCurrencyWriter)
    }
  }
  
  func currencyWriter(writer: CurrencyWriter, amountChanges _: String) {
    let getOtherCurrencyWriter = {(currencyWriter: CurrencyWriter) -> CurrencyWriter in
      if self.mainView.myCurrencyWriter === currencyWriter {
        return self.mainView.wantCurrencyWriter
      }
      return self.mainView.myCurrencyWriter
    }
    
    updateInterface(getOtherCurrencyWriter(writer), use: writer)
  }
  
  func currencyWriter(_: CurrencyWriter, currencyChanges _:Int) {
    updateInterface(mainView.wantCurrencyWriter, use: mainView.myCurrencyWriter)
  }
  
  private func updateInterface(writer: CurrencyWriter, use writerForGet: CurrencyWriter) {
    updateCurrencyWriter(writer, use: writerForGet)
    updateCurrencyProporcial(writer, use: writerForGet)
    
  }
  
  private func updateCurrencyWriter(writer: CurrencyWriter, use writerForGet: CurrencyWriter) {
    SIALog.Assert(nil != currencies)
    
    guard let fromAmount = amountFormatter.numberFromString(writerForGet.getCurrentAmount())?.doubleValue else {
      return
    }
    
    let toAmount = fromAmount * getCurrencyProporcial(writer, use: writerForGet)
    
    guard let toAmountStr = amountFormatter.stringFromNumber(toAmount) else {
      return
    }
    
    writer.setCurrentAmount(toAmountStr)
  }
  
  private func updateCurrencyProporcial(writer: CurrencyWriter, use writerForGet: CurrencyWriter) {
    SIALog.Assert(nil != currencies)
    
    let proporcial = getCurrencyProporcial(writer, use: writerForGet)
    guard let proporcialStr = amountFormatter.stringFromNumber(proporcial) else {
      return
    }
    
    let fromName = currencies![writerForGet.getSelectedCurrencyIndex()].name
    let toName = currencies![writer.getSelectedCurrencyIndex()].name
    
    mainView.setCurrencyProporcial(currencyFrom: fromName, currencyTo: toName, proporcial: proporcialStr)
    
  }
  
  private func getCurrencyProporcial(writer: CurrencyWriter, use writerForGet: CurrencyWriter) -> Double {
    let fromValue = currencies![writerForGet.getSelectedCurrencyIndex()].value
    let toValue = currencies![writer.getSelectedCurrencyIndex()].value
    return toValue / fromValue
  }
  
  private func showAlert(message: String, callback: () -> ()) {
     let alertController = UIAlertController(title: "Error", message:message, preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { _ in
      callback()
    }))
    
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  private let amountFormatter: NSNumberFormatter = {
    var result = NSNumberFormatter()
    result.numberStyle = NSNumberFormatterStyle.DecimalStyle
    result.locale = NSLocale.currentLocale()
    
    return result
  }()
}

