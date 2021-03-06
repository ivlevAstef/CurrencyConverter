//
//  ServerProtocol.swift
//  CurrencyConverter
//
//  Created by Alexander Ivlev on 24/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

protocol ServerProtocol {
  func getCurrencies(callback: (currencies: [String]?, error: String?)->())
  func getProporcial(fromCurrency fromCurrency: String, toCurrency: String, callback: (proporcial: Double?, error: String?)->())
}
