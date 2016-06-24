//
//  CurrencyWriter.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import SIALoggerSwift

protocol CurrencyWriterDelegate {
  func currencyWriter(currencyWriter: CurrencyWriter, amountChanges amount:Double)
  func currencyWriter(currencyWriter: CurrencyWriter, currencyChanges currency:Currency)
}

@IBDesignable
class CurrencyWriter: UIView,
  UIPickerViewDelegate, UIPickerViewDataSource,
  UITextFieldDelegate {
  
  var delegate: CurrencyWriterDelegate? = nil
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    NSBundle.mainBundle().loadNibNamed("CurrencyWriter", owner: self, options: nil)
    self.addSubview(self.view)
  }
  
  func setCurrencies(currencies: [Currency]) {
    self.currencies = currencies
    picker.reloadAllComponents()
    
    SIALog.Info("Updated currencies")
  }
  
  //UIPickerViewDataSource
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return currencies.count
  }
  
  //UIPickerViewDelegate
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    SIALog.Assert(0 <= row && row <= currencies.count)
    
    return currencies[row].name
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    SIALog.Assert(0 <= row && row <= currencies.count)
    
    SIALog.Info("Selected currency:\(currencies[row])")
    if let delegate = self.delegate {
      delegate.currencyWriter(self, currencyChanges: currencies[row])
    }
  }
  
  //UITextFieldDelegate
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    SIALog.Info("Updated amount")
    
    if let delegate = self.delegate, text = textField.text {
      if let amount = Double(text) {
        delegate.currencyWriter(self, amountChanges: amount)
      } else {
        textField.text = "0"
        delegate.currencyWriter(self, amountChanges: 0)
      }
    }
    
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  //Awake
  override func awakeFromNib() {
    super.awakeFromNib()
    
    localization()
    setupUI()
  }
  
  //private
  @IBOutlet private var view: UIView!
  @IBOutlet private var amount: UITextField!
  @IBOutlet private var currency: UILabel!
  @IBOutlet private var picker: UIPickerView!
  
  private var currencies: [Currency] = []
  private var pickerHidden = true
  
  private func localization() {
    amount.placeholder = "amount"
    currency.text = "currency"
  }
  
  private func setupUI() {
    hidePicker(false)
    
    self.picker.dataSource = self
    self.picker.delegate = self
    self.amount.delegate = self
    self.view.bounds.origin.y -= self.picker.bounds.size.height/2
    self.view.bounds.size.height = self.picker.bounds.size.height
    
    setCurrencies([Currency(name: "USB", value: 1.0),
      Currency(name: "RUB", value: 1.0),
      Currency(name: "AZB", value: 1.0),
      Currency(name: "CCC", value: 1.0),
      Currency(name: "FGF", value: 1.0),
      Currency(name: "QWE", value: 1.0),
      Currency(name: "RTY", value: 1.0),
      Currency(name: "EUR", value: 1.0),
      Currency(name: "TST", value: 1.0)])
  }
  
  override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    if !pickerHidden {
      if CGRectContainsPoint(self.picker.frame, point) {
        return true
      }
      hidePicker(true)
    }
    
    return super.pointInside(point, withEvent: event)
  }
  
  @IBAction func tappedToCurrency(sender: UITapGestureRecognizer) {
    showPicker(true)
  }
  
  private func showPicker(animated: Bool) {
    changePicker(animated, alpha: 1)
    pickerHidden = false
  }
  
  private func hidePicker(animated: Bool) {
    changePicker(animated, alpha: 0)
    pickerHidden = true
  }
  
  private func changePicker(animated: Bool, alpha: CGFloat) {
    let alphaValues = {
      self.currency.alpha = 1 - alpha
      self.picker.alpha = alpha
    }
    
    if animated {
      UIView.animateWithDuration(0.25, animations: alphaValues)
    } else {
      alphaValues()
    }
  }
}
