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
  private var currencies: [String]? = nil
  private var proporcialData: (from: String, to: String, value: Double) = ("","",1)
  
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
      dispatch_async(dispatch_get_main_queue(), {
        self.mainView.activityIndicator(show: false)
        
        guard let currencies = currenciesOpt else {
          self.showAlert(error ?? "No Internet") {
            //abort()
            self.loadCurrencies()
          }
          return
        }
        
        self.currencies = currencies.sort { $0 < $1 }
        
        self.mainView.myCurrencyWriter.setCurrencies(self.currencies!)
        self.mainView.wantCurrencyWriter.setCurrencies(self.currencies!)
        
        self.updateInterface(self.mainView.myCurrencyWriter, use: self.mainView.wantCurrencyWriter)
      })
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
    updateCurrencyProporcial(writer, use: writerForGet) { (success, error) in
        guard success else {
          self.showAlert(error ?? "Can't get information from serevr", callback: {})
          return
        }
        
        self.updateCurrencyWriter(writer, use: writerForGet)
        self.updateCurrencyProporcial(writer, use: writerForGet)
    }
  }
  
  private func updateCurrencyWriter(writer: CurrencyWriter, use writerForGet: CurrencyWriter) {
    SIALog.Assert(nil != currencies)
    
    guard let fromAmount = amountFormatter.numberFromString(writerForGet.getCurrentAmount())?.doubleValue else {
      return
    }
    
    guard let toAmountStr = amountFormatter.stringFromNumber(fromAmount * proporcialData.value) else {
      return
    }
    
    writer.setCurrentAmount(toAmountStr)
  }
  
  private func updateCurrencyProporcial(writer: CurrencyWriter, use writerForGet: CurrencyWriter) {
    SIALog.Assert(nil != currencies)
    
    guard let proporcialStr = amountFormatter.stringFromNumber(proporcialData.value) else {
      return
    }
    
    let fromName = currencies![writerForGet.getSelectedCurrencyIndex()]
    let toName = currencies![writer.getSelectedCurrencyIndex()]
    
    mainView.setCurrencyProporcial(currencyFrom: fromName, currencyTo: toName, proporcial: proporcialStr)
  }
  
  private var proporcialSemaphore = dispatch_semaphore_create(1)
  private func updateCurrencyProporcial(writer: CurrencyWriter, use writerForGet: CurrencyWriter, callback: (success: Bool, error: String?) -> ()) {
    let fromName = currencies![writerForGet.getSelectedCurrencyIndex()]
    let toName = currencies![writer.getSelectedCurrencyIndex()]
    
    if proporcialData.from == fromName && proporcialData.to == toName {
      callback(success: true, error: nil)
      return
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
      dispatch_semaphore_wait(self.proporcialSemaphore, DISPATCH_TIME_FOREVER)
      
      self.server.getProporcial(fromCurrency: fromName, toCurrency: toName) { proporcialOpt, error in
        dispatch_async(dispatch_get_main_queue()) {
          dispatch_semaphore_signal(self.proporcialSemaphore)
          
          guard let proporcial = proporcialOpt else {
            callback(success: false, error: error)
            return
          }
          
          self.proporcialData = (fromName, toName, proporcial)
          callback(success: true, error: nil)
        }
      }
    }
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

