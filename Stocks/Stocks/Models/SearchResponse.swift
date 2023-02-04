//
//  SearchResponse.swift
//  Stocks
//
//  Created by Elizeu RS on 07/11/22.
//

import Foundation

// codable - allows your json, that you get back from the api call to be mapped to this object, so long as the keys match and the value types match what is in your structure.
/// API response for search
struct SearchResponse: Codable {
  let count: Int
  let result: [SearchResult]
}

/// A single search result
struct SearchResult: Codable {
  let description: String
  let displaySymbol: String
  let symbol: String
  let type: String
}


// https://finnhub.io/api/v1/search?q=Apple&token=cdkip12ad3idmsqf0t5gcdkip12ad3idmsqf0t60
//{
//  "count": 22,
//  "result": [
//    {
//      "description": "Apple",
//      "displaySymbol": "A2R7JV.DU",
//      "symbol": "A2R7JV.DU",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A3K78W.MU",
//      "symbol": "A3K78W.MU",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A3KUT6.DU",
//      "symbol": "A3KUT6.DU",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A3KUT4.MU",
//      "symbol": "A3KUT4.MU",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "APCU.BE",
//      "symbol": "APCU.BE",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A3K78V.BE",
//      "symbol": "A3K78V.BE",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A1HKKY.HA",
//      "symbol": "A1HKKY.HA",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A3KUT6.MU",
//      "symbol": "A3KUT6.MU",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A19C0M.HM",
//      "symbol": "A19C0M.HM",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A3KUT6.BE",
//      "symbol": "A3KUT6.BE",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A19C0M.HA",
//      "symbol": "A19C0M.HA",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A3KUT5.BE",
//      "symbol": "A3KUT5.BE",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A1HKKY.BE",
//      "symbol": "A1HKKY.BE",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A3K78V.MU",
//      "symbol": "A3K78V.MU",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "APCT.MU",
//      "symbol": "APCT.MU",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A3KUT3.BE",
//      "symbol": "A3KUT3.BE",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A2R7JV.BE",
//      "symbol": "A2R7JV.BE",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "A19C0M.MU",
//      "symbol": "A19C0M.MU",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "APCA.MU",
//      "symbol": "APCA.MU",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "APCA.BE",
//      "symbol": "APCA.BE",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "APCL.HA",
//      "symbol": "APCL.HA",
//      "type": ""
//    },
//    {
//      "description": "Apple",
//      "displaySymbol": "APCL.DU",
//      "symbol": "APCL.DU",
//      "type": ""
//    }
//  ]
//}
