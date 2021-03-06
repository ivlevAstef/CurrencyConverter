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
  func currencyWriter(currencyWriter: CurrencyWriter, amountChanges amount:String)
  func currencyWriter(currencyWriter: CurrencyWriter, currencyChanges currencyIndex:Int)
}

//@IBDesignable
class CurrencyWriter: UIView,
  UIPickerViewDelegate, UIPickerViewDataSource,
  UITextFieldDelegate {
  
  var delegate: CurrencyWriterDelegate? = nil
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    NSBundle.mainBundle().loadNibNamed("CurrencyWriter", owner: self, options: nil)
    self.addSubview(self.view)
  }
  
  func setCurrencies(currencies: [String]) {
    SIALog.Assert(!currencies.isEmpty)
    
    self.currencies = currencies
    
    selectCurrency(0)
    picker.reloadAllComponents()
    
    SIALog.Info("Updated currencies")
  }
  
  func selectCurrency(index: Int) {
    SIALog.Assert(0 <= index && index < currencies.count)
    selectedRow = index
    self.currency.text = currencies[index]
  }
  
  func getSelectedCurrencyIndex() -> Int {
    return selectedRow
  }
  
  func setCurrentAmount(amount: String) {
    self.amount.text = amount
  }
  
  func getCurrentAmount() -> String {
    return self.amount.text ?? ""
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
    SIALog.Assert(0 <= row && row < currencies.count)
    
    if let label = view as? UILabel {
      label.text = currencies[row]
      return label
    }
    
    let label = UILabel(frame: currency.bounds)
    label.font = currency.font
    label.textAlignment = currency.textAlignment
    
    label.text = currencies[row]
    
    return label
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectCurrency(row)
    
    SIALog.Info("Selected currency:\(currencies[row])")
    if let delegate = self.delegate {
      delegate.currencyWriter(self, currencyChanges: row)
    }
  }
  
  //UITextFieldDelegate
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    SIALog.Info("Updated amount")
    
    updateAmount()
    return true
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let text = self.amount.text! as NSString
    self.amount.text = text.stringByReplacingCharactersInRange(range, withString: string)
    
    updateAmount()
    return false
  }
  
  private func updateAmount() {
    if let delegate = self.delegate, text = self.amount.text {
      delegate.currencyWriter(self, amountChanges: text)
    }
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
  
  private var currencies: [String] = []
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
