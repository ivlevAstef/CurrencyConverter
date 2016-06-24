//
//  MainView.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

class MainView: UIView {
  @IBOutlet var activityView: UIView!
  
  @IBOutlet private var titleLbl: UILabel!
  
  @IBOutlet private var myCurrencyLbl: UILabel!
  @IBOutlet private var wantCurrencyLbl: UILabel!
  
  @IBOutlet var myCurrencyWriter: CurrencyWriter!
  @IBOutlet var wantCurrencyWriter: CurrencyWriter!
  
  func activityIndicator(show show: Bool) {
    activityView.hidden = !show
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    localization()
  }
  
  override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    let myWriterPoint = convertPoint(point, toView: myCurrencyWriter)
    if !myCurrencyWriter.pointInside(myWriterPoint, withEvent: event) {
      myCurrencyWriter.endActions()
    }
    
    let wantWriterPoint = convertPoint(point, toView: wantCurrencyWriter)
    if !wantCurrencyWriter.pointInside(wantWriterPoint, withEvent: event) {
      wantCurrencyWriter.endActions()
    }
    
    return super.pointInside(point, withEvent: event)
  }
  
  private func localization() {
    titleLbl.text = "Currency Converter"
    myCurrencyLbl.text = "Currency I have:"
    wantCurrencyLbl.text = "Currency I want:"
  }
}
