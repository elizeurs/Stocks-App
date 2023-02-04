//
//  FinancialMetricsResponse.swift
//  Stocks
//
//  Created by Elizeu RS on 10/12/22.
//

import Foundation

/// Metrics response from API
struct FinancialMetricsResponse: Codable {
  let metric: Metrics
}

/// Financial metrics
struct Metrics: Codable {
  let TenDayAverageTradingVolume: Float
  let AnnualWeekHigh: Double
  let AnnualWeekLow: Double
  let AnnualWeekLowDate:  String
  let AnnualWeekPriceReturnDaily: Float
  let beta: Float
  
  enum CodingKeys: String, CodingKey {
    case TenDayAverageTradingVolume = "10DayAverageTradingVolume"
    case AnnualWeekHigh = "52WeekHigh"
    case AnnualWeekLow = "52WeekLow"
    case AnnualWeekLowDate = "52WeekLowDate"
    case AnnualWeekPriceReturnDaily = "52WeekPriceReturnDaily"
    case beta = "beta"
  }
}



//"metric": {
//  "10DayAverageTradingVolume": 32.50147,
//  "52WeekHigh": 310.43,
//  "52WeekLow": 149.22,
//  "52WeekLowDate": "2019-01-14",
//  "52WeekPriceReturnDaily": 101.96334,
//  "beta": 1.2989,
//},
