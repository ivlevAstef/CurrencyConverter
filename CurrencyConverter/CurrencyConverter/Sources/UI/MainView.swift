//
//  MainView.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

class MainView: UIView {
  
  @IBOutlet private var titleLbl: UILabel!
  
  @IBOutlet private var myCurrencyLbl: UILabel!
  @IBOutlet private var myCurrencyWriter: CurrencyWriter!
  
  @IBOutlet private var wantCurrencyLbl: UILabel!
  @IBOutlet private var wantCurrencyWriter: CurrencyWriter!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    localization()
  }
  
  func localization() {
    titleLbl.text = "Currency Converter"
    myCurrencyLbl.text = "Currency I have:"
    wantCurrencyLbl.text = "Currency I want:"
  }
}
