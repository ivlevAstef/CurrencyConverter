//
//  Server.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

class Server: ServerProtocol {
  
  func getCurrencies(callback: (currencies: [Currency]?, error: String?)->()) {
    let request = ServerRequest(method: "latest")
    
    request.GET { (dataOpt, error) in
      guard let data = dataOpt else {
        callback(currencies: nil, error: error)
        return
      }
      
      guard let currencies = self.parse(data) else {
        callback(currencies: nil, error: "Can't parse server response")
        return
      }
      
      callback(currencies: currencies, error: nil)
    }
  }
  
  private func parse(data: NSData) -> [Currency]? {
    do {
      let objects = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
      
      var result: [Currency] = []
      
      if let baseCurrencyName = objects["base"] as? String {
        result.append(Currency(name: baseCurrencyName, value: 1.0))
      }
      
      if let currencies = objects["rates"] as? Dictionary<String, Double> {
        for (name, value) in currencies {
          result.append(Currency(name: name, value: value))
        }
      }
      
      return result
    } catch {
      return nil
    }
  }
}
