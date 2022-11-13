//
//  MarketDataResponse.swift
//  Stocks
//
//  Created by Elizeu RS on 12/11/22.
//

import Foundation

struct MarketDataResponse: Codable {
  let open: [Double]
  let close: [Double]
  let high: [Double]
  let low: [Double]
  let status: String
  let timestamps: [TimeInterval]
  
  enum CodingKeys: String, CodingKey {
    case open = "o"
    case close = "c"
    case high = "h"
    case low = "l"
    case status = "s"
    case timestamps = "t"
  }
  
  var candleSticks: [CandleStick] {
    var result = [CandleStick]()
    
    for index in 0..<open.count {
      result.append(
        .init(
          date: Date(timeIntervalSince1970: timestamps[index]),
          high: high[index],
          low: low[index],
          open: open[index],
          close: close[index]
        )
      )
    }
    
    let sortedData = result.sorted(by: { $0.date < $1.date })
//    print(sortedData[0])
    return sortedData
  }
}

struct CandleStick {
  let date: Date
  let high: Double
  let low: Double
  let open: Double
  let close: Double
}


//{
//  "c": [
//    217.68,
//    221.03,
//    219.89
//  ],
//  "h": [
//    222.49,
//    221.5,
//    220.94
//  ],
//  "l": [
//    217.19,
//    217.1402,
//    218.83
//  ],
//  "o": [
//    221.03,
//    218.55,
//    220
//  ],
//  "s": "ok",
//  "t": [
//    1569297600,
//    1569384000,
//    1569470400
//  ],
//  "v": [
//    33463820,
//    24018876,
//    20730608
//  ]
//}
