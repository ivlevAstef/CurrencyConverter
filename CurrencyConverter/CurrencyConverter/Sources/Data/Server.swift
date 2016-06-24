//
//  Server.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation
import SIALoggerSwift

class Server: ServerProtocol {
  
  func getCurrencies(callback: (currencies: [String]?, error: String?)->()) {
    let request = ServerRequest(method: "latest")
    
    request.GET { (dataOpt, error) in
      guard let data = dataOpt else {
        callback(currencies: nil, error: error)
        return
      }
      
      guard let currencies = self.parseCurrencies(data) else {
        callback(currencies: nil, error: "Can't parse server response")
        return
      }
      
      callback(currencies: currencies, error: nil)
    }
  }
  
  func getProporcial(fromCurrency fromCurrency: String, toCurrency: String, callback: (proporcial: Double?, error: String?)->()) {
    guard fromCurrency != toCurrency else {
      callback(proporcial: 1.0, error: nil)
      return
    }
    
    let request = ServerRequest(method: "latest?base=\(fromCurrency)&symbols=\(toCurrency)")
    
    request.GET { (dataOpt, error) in
      guard let data = dataOpt else {
        callback(proporcial: nil, error: error)
        return
      }
      
      guard let proporical = self.parseProporcial(data) else {
        callback(proporcial: nil, error: "Can't parse server response")
        return
      }
      
      callback(proporcial: proporical, error: nil)
    }
  }
  
  private func parseCurrencies(data: NSData) -> [String]? {
    SIALog.Info("Start parse currencies")
    
    do {
      let objects = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
      
      var result: [String] = []
      
      if let baseCurrencyName = objects["base"] as? String {
        result.append(baseCurrencyName)
      }
      
      if let currencies = objects["rates"] as? Dictionary<String, Double> {
        for (name, _) in currencies {
          result.append(name)
        }
      }
    
      SIALog.Info("Parse currencies success: \(result)")
      return result
    } catch {
      SIALog.Error("Parse currencies failed")
      return nil
    }
  }
  
  private func parseProporcial(data: NSData) -> Double? {
    SIALog.Info("Start parse proporcial")
    
    do {
      let objects = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
      
      if let currencies = objects["rates"] as? Dictionary<String, Double> {
        for (_, value) in currencies {
          SIALog.Info("Parse proporcial success")
          return value
        }
      }
      
    } catch {
    }
    
    SIALog.Error("Parse proporcial failed")
    return nil
  }
}
