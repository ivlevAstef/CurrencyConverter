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
    SIALog.Assert(!currencies.isEmpty)
    
    self.currencies = currencies
    selectCurrency(currencies[0])
    picker.reloadAllComponents()
    
    SIALog.Info("Updated currencies")
  }
  
  func selectCurrency(currency: Currency) {
    for i in 0..<currencies.count {
      if currency === currencies[i] {
        selectedRow = i
        self.currency.text = currency.name
        return
      }
    }
    
    SIALog.Error("Can't found \(currency) in currencies")
  }
  
  func endActions() {
    hidePicker(true)
    amount.resignFirstResponder()
  }
  
  //UIPickerViewDataSource
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return currencies.count
  }
  
  //UIPickerViewDelegate
  func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
    SIALog.Assert(0 <= row && row <= currencies.count)
    
    if let label = view as? UILabel {
      label.text = currencies[row].name
      return label
    }
    
    let label = UILabel(frame: currency.bounds)
    label.font = currency.font
    label.textAlignment = currency.textAlignment
    
    label.text = currencies[row].name
    
    return label
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    SIALog.Assert(0 <= row && row < currencies.count)
    selectCurrency(currencies[row])
    
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
  private var selectedRow = 0
  
  private func localization() {
    amount.placeholder = "amount"
    currency.text = ""
  }
  
  private func setupUI() {
    hidePicker(false)
    
    picker.dataSource = self
    picker.delegate = self
    amount.delegate = self
    
    picker.showsSelectionIndicator = false
    
    view.bounds.origin.y = picker.frame.origin.y
    view.bounds.size.height = picker.frame.size.height
    
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
    //rollback
    picker.selectRow(selectedRow, inComponent: 0, animated: false)
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
