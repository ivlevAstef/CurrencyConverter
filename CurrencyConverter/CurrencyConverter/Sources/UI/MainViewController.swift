//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import DITranquillity

class MainViewController: UIViewController {
  private let server : ServerProtocol
  private var mainView: MainView! { return self.view as! MainView }
  
  required init?(coder aDecoder: NSCoder) {
    server = *!DIMain.container!
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
}

